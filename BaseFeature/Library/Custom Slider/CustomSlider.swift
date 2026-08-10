//
//  CustomSlider.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 05/08/26.
//

import SwiftUI


struct CustomGradientSlider: View {
    @Binding var value: Double
    let bounds: ClosedRange<Double>
    var step: Double? = nil // step ને ઓપ્શનલ બનાવ્યું
    
    let leftColor = LinearGradient(colors: [.red, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
    let rightColor = LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let thumbDiameter: CGFloat = 14
            let trackHeight: CGFloat = 6
            
            // Calculate progress percentage (0.0 to 1.0)
            let percentage = CGFloat((value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound))
            let activeWidth = max(0, min(totalWidth, percentage * totalWidth))
            
            ZStack(alignment: .leading) {
                // 1. Right Side Track
                Capsule()
                    .fill(leftColor)
                    .frame(height: trackHeight)
                
                // 2. Left Side Track
                Capsule()
                    .fill(rightColor)
                    .frame(width: activeWidth, height: trackHeight)
                
                // 3. Thumb (Circle)
                Circle()
                    .fill(rightColor)
                    .frame(width: thumbDiameter, height: thumbDiameter)
                    .offset(x: max(0, min(totalWidth - thumbDiameter, activeWidth - thumbDiameter / 2)))
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        let locationX = gesture.location.x
                        let newPercentage = max(0, min(1, locationX / totalWidth))
                        let rawValue = bounds.lowerBound + Double(newPercentage) * (bounds.upperBound - bounds.lowerBound)
                        
                        let finalValue: Double
                        
                        // ૧. જો step આપેલું હોય તો જ rounding કરવું
                        if let step = step, step > 0 {
                            let steppedValue = (rawValue / step).rounded() * step
                            finalValue = max(bounds.lowerBound, min(bounds.upperBound, steppedValue))
                        } else {
                            // ૨. નહીંતર એકદમ સ્મૂથ (Continuous) વેલ્યૂ સેટ કરવી
                            finalValue = max(bounds.lowerBound, min(bounds.upperBound, rawValue))
                        }
                        
                        if value != finalValue {
                            value = finalValue
                        }
                    }
            )
        }
        .frame(height: 30)
    }
}
