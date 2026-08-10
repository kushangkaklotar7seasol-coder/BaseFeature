//
//  CustomPopUp.swift
//  navigation
//
//  Created by Kushang  on 24/06/25.
//

import SwiftUI

// --- Configuration for your CustomPopUp View ---
struct CustomPopUpConfig {
    var customPopUpCornerRadius: CGFloat = 0
    var customPopUpHorizontalPadding: CGFloat = 0
    var customPopUpVerticalPadding: CGFloat = 0
    var customPopUpBackgroundColor: Color = Color(.clear)
    var customPopUpShadowRadius: CGFloat = 10
    var customPopUpShadowColor: Color = Color.black.opacity(0.2)
    var isCustomPopUpDismissibleByTapOutside: Bool = true
    var customPopUpAnimation: Animation = .snappy()
}

extension View {
    @ViewBuilder
    func customPopUpView<Content: View>(
        _ showCustomPopUp: Binding<Bool>,
        config: CustomPopUpConfig = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self // The base view this modifier is applied to
            .overlay {
                if showCustomPopUp.wrappedValue {
                    ZStack {
                        // --- Overlay Background (for dimming and dismissal) ---
                        if config.isCustomPopUpDismissibleByTapOutside {
                            Color.black.opacity(0.4) // Dim the background
                                .ignoresSafeArea()
                                .onTapGesture {
                                    showCustomPopUp.wrappedValue = false // Dismiss on tap outside
                                }
                        }

                        // --- The Actual CustomPopUp Content ---
                        content()
                            .background(config.customPopUpBackgroundColor) // Apply background to content
                            .clipShape(RoundedRectangle(cornerRadius: config.customPopUpCornerRadius))
                            .shadow(color: config.customPopUpShadowColor, radius: config.customPopUpShadowRadius)
                            .padding(.horizontal, config.customPopUpHorizontalPadding)
                            .padding(.vertical, config.customPopUpVerticalPadding) // Apply vertical padding
                            // Center the popup
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .transition(.opacity.combined(with: .scale)) // Example transition
                            // You can add .offset, .position, etc., for more specific placement
                    }
                    .animation(config.customPopUpAnimation, value: showCustomPopUp.wrappedValue) // Animate the whole ZStack
                }
            }
    }
}
