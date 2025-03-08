//
//  ContentView.swift
//  tutorialonexcode
//
//  Created by Monei Bakang Mothuti on 08/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var displayText = "0"
    @State private var currentOperation: CalculatorOperation? = nil
    @State private var previousNumber: Double? = nil
    @State private var shouldReplaceDisplay = true
    @State private var isInScientificMode = false
    @State private var isInRadianMode = true
    
    enum CalculatorOperation {
        case addition, subtraction, multiplication, division
        case power, squareRoot, percentage, sine, cosine, tangent, logarithm, naturalLog
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(hex: "1c1c1e"), Color(hex: "2c2c2e")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                // Display area
                displayArea
                
                // Toggle for Scientific Mode
                scientificModeToggle
                
                // Scientific buttons (conditionally shown)
                if isInScientificMode {
                    scientificButtons
                }
                
                // Main calculator buttons
                calculatorButtons
            }
            .padding()
        }
    }
    
    var displayArea: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "121214"))
                .frame(height: 100)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
            
            Text(displayText)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(.top, 10)
    }
    
    var scientificModeToggle: some View {
        Toggle(isOn: $isInScientificMode) {
            Text("Scientific Mode")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "FF9500")))
    }
    
    var scientificButtons: some View {
        VStack(spacing: 12) {
            HStack {
                Button(isInRadianMode ? "RAD" : "DEG") {
                    isInRadianMode.toggle()
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("sin") { performScientificOperation(.sine) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("cos") { performScientificOperation(.cosine) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("tan") { performScientificOperation(.tangent) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
            }
            
            HStack {
                Button("π") {
                    displayText = "\(Double.pi)"
                    shouldReplaceDisplay = true
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("x²") {
                    calculateSquare()
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("√") { performScientificOperation(.squareRoot) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("xʸ") {
                    setOperation(.power)
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
            }
            
            HStack {
                Button("log") { performScientificOperation(.logarithm) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("ln") { performScientificOperation(.naturalLog) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("e") {
                    displayText = "\(M_E)"
                    shouldReplaceDisplay = true
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
                
                Button("1/x") {
                    if let num = Double(displayText), num != 0 {
                        displayText = formatResult(1.0 / num)
                        shouldReplaceDisplay = true
                    }
                }
                .buttonStyle(FunctionButtonStyle(background: Color(hex: "1C1C1E")))
            }
        }
    }
    
    var calculatorButtons: some View {
        VStack(spacing: 12) {
            // First row
            HStack {
                Button("AC") { clear() }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "505050")))
                
                Button("+/-") { negateNumber() }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "505050")))
                
                Button("%") { performScientificOperation(.percentage) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "505050")))
                
                Button("÷") { setOperation(.division) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "FF9500")))
            }
            
            // Second row
            HStack {
                Button("7") { appendDigit("7") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("8") { appendDigit("8") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("9") { appendDigit("9") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("×") { setOperation(.multiplication) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "FF9500")))
            }
            
            // Third row
            HStack {
                Button("4") { appendDigit("4") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("5") { appendDigit("5") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("6") { appendDigit("6") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("-") { setOperation(.subtraction) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "FF9500")))
            }
            
            // Fourth row
            HStack {
                Button("1") { appendDigit("1") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("2") { appendDigit("2") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("3") { appendDigit("3") }
                    .buttonStyle(NumberButtonStyle())
                
                Button("+") { setOperation(.addition) }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "FF9500")))
            }
            
            // Fifth row
            HStack {
                Button("0") { appendDigit("0") }
                    .buttonStyle(ZeroButtonStyle())
                
                Button(".") { appendDecimal() }
                    .buttonStyle(NumberButtonStyle())
                
                Button("=") { calculate() }
                    .buttonStyle(FunctionButtonStyle(background: Color(hex: "FF9500")))
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func appendDigit(_ digit: String) {
        if shouldReplaceDisplay || displayText == "0" {
            displayText = digit
            shouldReplaceDisplay = false
        } else {
            displayText += digit
        }
    }
    
    private func appendDecimal() {
        if shouldReplaceDisplay {
            displayText = "0."
            shouldReplaceDisplay = false
        } else if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    private func clear() {
        displayText = "0"
        currentOperation = nil
        previousNumber = nil
        shouldReplaceDisplay = true
    }
    
    private func negateNumber() {
        if let value = Double(displayText) {
            displayText = formatResult(-value)
        }
    }
    
    private func calculateSquare() {
        if let value = Double(displayText) {
            displayText = formatResult(value * value)
            shouldReplaceDisplay = true
        }
    }
    
    private func setOperation(_ operation: CalculatorOperation) {
        if let value = Double(displayText) {
            previousNumber = value
            currentOperation = operation
            shouldReplaceDisplay = true
        }
    }
    
    private func performScientificOperation(_ operation: CalculatorOperation) {
        guard let value = Double(displayText) else { return }
        
        var result: Double = 0
        
        switch operation {
        case .percentage:
            result = value / 100.0
        case .squareRoot:
            if value >= 0 {
                result = sqrt(value)
            } else {
                displayText = "Error"
                return
            }
        case .sine:
            let radValue = isInRadianMode ? value : value * .pi / 180.0
            result = sin(radValue)
        case .cosine:
            let radValue = isInRadianMode ? value : value * .pi / 180.0
            result = cos(radValue)
        case .tangent:
            let radValue = isInRadianMode ? value : value * .pi / 180.0
            result = tan(radValue)
        case .logarithm:
            if value > 0 {
                result = log10(value)
            } else {
                displayText = "Error"
                return
            }
        case .naturalLog:
            if value > 0 {
                result = log(value)
            } else {
                displayText = "Error"
                return
            }
        default:
            return
        }
        
        displayText = formatResult(result)
        shouldReplaceDisplay = true
    }
    
    private func calculate() {
        guard let operation = currentOperation, let previous = previousNumber, let current = Double(displayText) else {
            return
        }
        
        var result: Double = 0
        
        switch operation {
        case .addition:
            result = previous + current
        case .subtraction:
            result = previous - current
        case .multiplication:
            result = previous * current
        case .division:
            if current != 0 {
                result = previous / current
            } else {
                displayText = "Error"
                return
            }
        case .power:
            result = pow(previous, current)
        default:
            return
        }
        
        displayText = formatResult(result)
        currentOperation = nil
        shouldReplaceDisplay = true
    }
    
    private func formatResult(_ result: Double) -> String {
        // Remove trailing zeros
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        
        if let formattedString = formatter.string(from: NSNumber(value: result)) {
            return formattedString
        }
        
        return String(result)
    }
}

// MARK: - Button Styles

struct NumberButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(Color(hex: "333333").opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .medium))
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct ZeroButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60)
            .background(Color(hex: "333333").opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .medium))
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct FunctionButtonStyle: ButtonStyle {
    var background: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(background.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .font(.system(size: 24, weight: .medium))
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// MARK: - Extensions

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
