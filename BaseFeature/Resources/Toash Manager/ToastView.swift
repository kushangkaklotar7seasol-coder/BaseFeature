//
//  ToastView.swift
//  ToastDemo
//
//  Created by Ondrej Kvasnovsky on 1/30/23.
//

import SwiftUI
import Combine

// MARK: - Toast Type
enum ToastType {
    case success
    case error
    case warning
    case info
    
    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

// MARK: - Toast Item
struct ToastItem: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    let duration: TimeInterval
}

@MainActor
final class Toast: ObservableObject {
    static let shared = Toast()
    
    @Published var currentToast: ToastItem?
    
    private init() {}
    
    func show(
        message: String,
        type: ToastType = .info,
        duration: TimeInterval = 3.0
    ) {
        DispatchQueue.main.async {
            self.currentToast = ToastItem(
                message: message,
                type: type,
                duration: duration
            )
        }
        
        // Auto dismiss
        Task {
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if currentToast?.id == currentToast?.id {
                currentToast = nil
            }
        }
    }
    
    // Convenience methods
    func success(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .success, duration: duration)
    }
    
    func error(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .error, duration: duration)
    }
    
    func warning(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .warning, duration: duration)
    }
    
    func info(_ message: String, duration: TimeInterval = 3.0) {
        show(message: message, type: .info, duration: duration)
    }
    
    func dismiss() {
        currentToast = nil
    }
}

// MARK: - Toast View
struct ToastView: View {
    let toast: ToastItem
    let onDismiss: () -> Void
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: toast.type.icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
//            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(toast.type.color)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .offset(y: dragOffset)
        .opacity(dragOffset < -50 ? 0 : 1)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height < 0 {
                        dragOffset = gesture.translation.height
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.height < -50 {
                        onDismiss()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @ObservedObject var manager = Toast.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                if let toast = manager.currentToast {
                    ToastView(toast: toast) {
                        manager.dismiss()
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top)
                                .combined(with: .opacity)
                                .combined(with: .scale(scale: 0.9, anchor: .top)),
                            removal: .move(edge: .top)
                                .combined(with: .opacity)
                        )
                    )
                    .zIndex(1000)
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: manager.currentToast?.id)
        }
    }
}

// MARK: - View Extension
extension View {
    func toastManager() -> some View {
        modifier(ToastModifier())
    }
}

