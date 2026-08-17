//
//  CalculatorScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct CalculatorScreen: View {
 
    // MARK: - State
    @State private var displayValue: String = "0"
    @State private var currentNumber: Double = 0
    @State private var storedNumber: Double = 0
    @State private var pendingOperation: Operation? = nil
    @State private var isTypingNumber: Bool = false
    @State private var justEvaluated: Bool = false
 
    // Small gray indicator showing which operator was last pressed (+, −, ×, ÷, %)
    @State private var operatorIndicator: String = ""
 
    // Button layout matching the screenshot
    let buttons: [[CalculatorButtonType]] = [
        [.icon("delete.left", .delete), .text("C", .clear), .text("%", .percent), .icon("divide", .operation(.divide))],
        [.text("7", .digit), .text("8", .digit), .text("9", .digit), .icon("multiply", .operation(.multiply))],
        [.text("4", .digit), .text("5", .digit), .text("6", .digit), .icon("minus", .operation(.subtract))],
        [.text("1", .digit), .text("2", .digit), .text("3", .digit), .icon("plus", .operation(.add))],
        [.text("+/-", .toggleSign), .text("0", .digit), .text(".", .decimal), .icon("equal", .equals)]
    ]
 
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DefaultDesign.Header(name: "Percentage Calculator")
                    .padding(.horizontal, 16)
 
                Spacer()
 
                // Display
                VStack(alignment: .trailing, spacing: 6) {
                    // Small gray operator symbol shown above the main number
                    Text(operatorIndicator)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        .opacity(operatorIndicator.isEmpty ? 0 : 1)
                        .frame(height: 18)
 
                    Text(displayValue)
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
                    ForEach(0..<buttons.count, id: \.self) { row in
                        HStack(spacing: 14) {
                            ForEach(0..<buttons[row].count, id: \.self) { col in
                                let type = buttons[row][col]
                                CalculatorButtonView(type: type) {
                                    handleTap(type)
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
 
    // MARK: - Logic
 
    private func handleTap(_ type: CalculatorButtonType) {
        switch type.action {
 
        case .digit:
            appendDigit(type.rawText)
 
        case .decimal:
            appendDecimal()
 
        case .toggleSign:
            toggleSign()
 
        case .clear:
            clearAll()
 
        case .delete:
            deleteLast()
 
        case .percent:
            applyPercent()
 
        case .operation(let op):
            setOperation(op)
 
        case .equals:
            evaluate()
        }
    }
 
    private func appendDigit(_ digit: String) {
        if justEvaluated {
            displayValue = digit
            justEvaluated = false
        } else if !isTypingNumber || displayValue == "0" {
            displayValue = digit
        } else {
            displayValue += digit
        }
        isTypingNumber = true
        currentNumber = Double(displayValue) ?? 0
    }
 
    private func appendDecimal() {
        if justEvaluated {
            displayValue = "0."
            justEvaluated = false
            isTypingNumber = true
            return
        }
        if !displayValue.contains(".") {
            displayValue += "."
            isTypingNumber = true
        }
    }
 
    private func toggleSign() {
        currentNumber *= -1
        displayValue = format(currentNumber)
    }
 
    private func clearAll() {
        displayValue = "0"
        currentNumber = 0
        storedNumber = 0
        pendingOperation = nil
        isTypingNumber = false
        justEvaluated = false
        operatorIndicator = ""
    }
 
    private func deleteLast() {
        guard isTypingNumber, !displayValue.isEmpty else { return }
        displayValue.removeLast()
        if displayValue.isEmpty || displayValue == "-" {
            displayValue = "0"
            isTypingNumber = false
        }
        currentNumber = Double(displayValue) ?? 0
    }
 
    private func applyPercent() {
        currentNumber = currentNumber / 100
        displayValue = format(currentNumber)
        operatorIndicator = "%"
    }
 
    private func setOperation(_ op: Operation) {
        // If an operation is already pending and user is chaining, evaluate first
        if pendingOperation != nil, isTypingNumber {
            evaluate()
        } else {
            storedNumber = currentNumber
        }
        pendingOperation = op
        isTypingNumber = false
        justEvaluated = false
        operatorIndicator = symbol(for: op)
    }
 
    private func evaluate() {
        guard let op = pendingOperation else { return }
        let result: Double
 
        switch op {
        case .add:
            result = storedNumber + currentNumber
        case .subtract:
            result = storedNumber - currentNumber
        case .multiply:
            result = storedNumber * currentNumber
        case .divide:
            result = currentNumber == 0 ? 0 : storedNumber / currentNumber
        }
 
        currentNumber = result
        storedNumber = result
        displayValue = format(result)
        pendingOperation = nil
        isTypingNumber = false
        justEvaluated = true
        operatorIndicator = ""
    }
 
    private func symbol(for op: Operation) -> String {
        switch op {
        case .add: return "+"
        case .subtract: return "−"
        case .multiply: return "×"
        case .divide: return "÷"
        }
    }
 
    private func format(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        var text = String(value)
        // trim trailing zeros for cleaner display
        if text.contains(".") {
            while text.hasSuffix("0") {
                text.removeLast()
            }
            if text.hasSuffix(".") {
                text.removeLast()
            }
        }
        return text
    }
}
 
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
            .clipShape(Circle())
        }
    }
}
 
#Preview {
    CalculatorScreen()
}
 
