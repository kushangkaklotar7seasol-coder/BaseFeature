//
//  CalculatorScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI
import Combine

// MARK: - Models

enum Operation {
    case add, subtract, multiply, divide
}

enum ButtonAction {
    case digit
    case decimal
    case toggleSign
    case clear
    case delete
    case percent
    case operation(Operation)
    case equals
}

enum CalculatorButtonType {
    case text(String, ButtonAction)
    case icon(String, ButtonAction)

    var isOperator: Bool {
        switch action {
        case .operation, .equals:
            return true
        default:
            return false
        }
    }

    var action: ButtonAction {
        switch self {
        case .text(_, let action): return action
        case .icon(_, let action): return action
        }
    }

    var rawText: String {
        switch self {
        case .text(let value, _): return value
        case .icon: return ""
        }
    }
}

// MARK: - View

struct CalculatorScreen: View {
    @StateObject private var viewModel = CalculatorViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DefaultDesign.Header(name: "PERCENTAGE_CALCULATOR".localized())
                    .padding(.horizontal, 16)

                Spacer()

                // Display
                VStack(alignment: .trailing, spacing: 6) {
                    Text(viewModel.operatorIndicator)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .opacity(viewModel.operatorIndicator.isEmpty ? 0 : 1)
                        .frame(height: 18)

                    Text(viewModel.displayValue)
                        .font(.system(size: 64, weight: .regular))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)

                // Button Grid
                VStack(spacing: 14) {
                    ForEach(0..<viewModel.buttons.count, id: \.self) { row in
                        HStack(spacing: 14) {
                            ForEach(0..<viewModel.buttons[row].count, id: \.self) { col in
                                let type = viewModel.buttons[row][col]
                                CalculatorButtonView(type: type) {
                                    viewModel.handleTap(type)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .defaultPage()
    }
}

// MARK: - Button View

struct CalculatorButtonView: View {
    let type: CalculatorButtonType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                switch type {
                case .text(let value, _):
                    Text(value)
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.white)

                case .icon(let name, _):
                    Image(systemName: name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 68)
            .background(
                Group {
                    if type.isOperator {
                        ZStack { }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.leftTorightGradient)
                    } else {
                        Color.white.opacity(0.06)
                    }
                }
            )
            .modifier(ButtonShapeModifier())
        }
    }
}

struct ButtonShapeModifier: ViewModifier {
    func body(content: Content) -> some View {
        if Device.isIpad {
            content.clipShape(RoundedRectangle(cornerRadius: 68))
        } else {
            content.clipShape(Circle())
        }
    }
}

#Preview {
    CalculatorScreen()
}
