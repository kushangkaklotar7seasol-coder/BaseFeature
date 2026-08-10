//
//  CustomSheet.swift
//  navigation
//
//  Created by Kushang  on 24/06/25.
//

import SwiftUI

// --- Configuration for your CustomSheet ---
struct CustomSheetConfig {
    var maxDetent: PresentationDetent = .fraction(0.99)
    var customSheetCornerRadius: CGFloat = 0
    var isCustomSheetInteractiveDismissDisabled: Bool = false
    var customSheetHorizontalPadding: CGFloat = 0
    var customSheetBottomPadding: CGFloat = 0
    var customSheetBlueEffect: Int = 0
    var onDismiss: (() -> Void)? = nil // Add dismiss callback
}

extension View {
    @ViewBuilder
    func customSheetView<Content: View>(
        _ showCustomSheet: Binding<Bool>,
        config: CustomSheetConfig = .init(maxDetent: .fraction(0.99)),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .sheet(isPresented: showCustomSheet) {
                // Call onDismiss when sheet is dismissed
                config.onDismiss?()
            } content: {
                if #available(iOS 16.4, *) {
                    content()
                        .environment(\.customSheetDismiss, CustomSheetDismissAction {
                            showCustomSheet.wrappedValue = false
                            config.onDismiss?()
                        })
                        .clipShape(.rect(cornerRadius: config.customSheetCornerRadius))
                        .padding(.horizontal, config.customSheetHorizontalPadding)
                        .padding(.bottom, config.customSheetBottomPadding)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea(.container, edges: .all)
                        .presentationDetents([config.maxDetent])
                        .presentationCornerRadius(0)
                        .presentationDragIndicator(.hidden)
                        .interactiveDismissDisabled(config.isCustomSheetInteractiveDismissDisabled)
                        .presentationBackground {
                            if config.customSheetBlueEffect == 0 {
                                Color.clear
                                    .ignoresSafeArea()
                            } else {
                                Rectangle()
                                    .fill(getCustomSheetMaterial(for: config.customSheetBlueEffect))
                                    .ignoresSafeArea()
                            }
                        }
                } else {
                    content()
                        .environment(\.customSheetDismiss, CustomSheetDismissAction {
                            showCustomSheet.wrappedValue = false
                            config.onDismiss?()
                        })
                        .clipShape(RoundedRectangle(cornerRadius: config.customSheetCornerRadius))
                        .padding(.horizontal, config.customSheetHorizontalPadding)
                        .padding(.bottom, config.customSheetBottomPadding)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea(.container, edges: .all)
                }
            }
    }

    private func getCustomSheetMaterial(for effect: Int) -> Material {
        switch effect {
        case 1:
            return .ultraThinMaterial
        case 2:
            return .thinMaterial
        case 3:
            return .regularMaterial
        case 4:
            return .thickMaterial
        case 5:
            return .ultraThickMaterial
        default:
            return .ultraThinMaterial
        }
    }
}

// MARK: - Custom Dismiss Environment
struct CustomSheetDismissAction {
    let action: () -> Void
    
    func callAsFunction() {
        action()
    }
}

private struct CustomSheetDismissKey: EnvironmentKey {
    static let defaultValue: CustomSheetDismissAction? = nil
}

extension EnvironmentValues {
    var customSheetDismiss: CustomSheetDismissAction? {
        get { self[CustomSheetDismissKey.self] }
        set { self[CustomSheetDismissKey.self] = newValue }
    }
}

// UIViewRepresentable for removing sheet shadow (if needed)
fileprivate struct RemoveSheetShadow: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        DispatchQueue.main.async {
            if let shadowView = view.dropShadowView {
                shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

extension UIView {
    var dropShadowView: UIView? {
        if let superview, String(describing: type(of: superview)) == "UIDropShadowView" {
            return superview
        }

        return superview?.dropShadowView
    }
}
