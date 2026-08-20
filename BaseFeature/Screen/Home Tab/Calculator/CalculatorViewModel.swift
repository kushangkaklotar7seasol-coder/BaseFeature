//
//  CalculatorViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 19/08/26.
//

import Combine
import Foundation

class CalculatorViewModel: ObservableObject {
    @Published var displayValue: String = "0"
    @Published var operatorIndicator: String = ""

    private var currentNumber: Double = 0
    private var storedNumber: Double = 0
    private var pendingOperation: Operation? = nil
    private var isTypingNumber: Bool = false
    private var justEvaluated: Bool = false

    let buttons: [[CalculatorButtonType]] = [
        [.icon("delete.left", .delete), .text("C", .clear), .text("%", .percent), .icon("divide", .operation(.divide))],
        [.text("7", .digit), .text("8", .digit), .text("9", .digit), .icon("multiply", .operation(.multiply))],
        [.text("4", .digit), .text("5", .digit), .text("6", .digit), .icon("minus", .operation(.subtract))],
        [.text("1", .digit), .text("2", .digit), .text("3", .digit), .icon("plus", .operation(.add))],
        [.text("+/-", .toggleSign), .text("0", .digit), .text(".", .decimal), .icon("equal", .equals)]
    ]

    func handleTap(_ type: CalculatorButtonType) {
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
        if displayValue == "Error" { clearAll() }

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
        if displayValue == "Error" { clearAll() }

        if justEvaluated {
            displayValue = "0."
            justEvaluated = false
            isTypingNumber = true
            currentNumber = 0
            return
        }

        if !isTypingNumber {
            displayValue = "0."
            isTypingNumber = true
        } else if !displayValue.contains(".") {
            displayValue += "."
        }
    }

    private func toggleSign() {
        guard displayValue != "Error" else { return }
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
        guard !displayValue.isEmpty, displayValue != "Error" else { return }//isTypingNumber,
        displayValue.removeLast()
        if displayValue.isEmpty || displayValue == "-" {
            displayValue = "0"
            isTypingNumber = false
        }
        currentNumber = Double(displayValue) ?? 0
    }

    // MARK: - Standard Calculator Percentage Logic
    private func applyPercent() {
        guard displayValue != "Error" else { return }

        if let op = pendingOperation {
            switch op {
            case .add, .subtract:
                // E.g., 200 + 10% => 10% of 200 = 20
                currentNumber = storedNumber * (currentNumber / 100)
            case .multiply, .divide:
                // E.g., 200 * 10% => 10% = 0.1
                currentNumber = currentNumber / 100
            }
        } else {
            // Standalone percentage: 50% => 0.5
            currentNumber = currentNumber / 100
        }

        displayValue = format(currentNumber)
    }

    private func setOperation(_ op: Operation) {
        guard displayValue != "Error" else { return }

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
        guard let op = pendingOperation, displayValue != "Error" else { return }
        let result: Double

        switch op {
        case .add:
            result = storedNumber + currentNumber
        case .subtract:
            result = storedNumber - currentNumber
        case .multiply:
            result = storedNumber * currentNumber
        case .divide:
            if currentNumber == 0 {
                displayValue = "Error"
                operatorIndicator = ""
                pendingOperation = nil
                return
            } else {
                result = storedNumber / currentNumber
            }
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
        if value.isNaN || value.isInfinite {
            return "Error"
        }
        if value.truncatingRemainder(dividingBy: 1) == 0 && abs(value) < 1e15 {
            return String(format: "%.0f", value)
        }
        var text = String(value)
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
