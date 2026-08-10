//
//  CustomSegmentedControl.swift
//  Movies Guide
//
//  Created by Kushang  on 14/12/25.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    var onSelect: ((Int) -> Void)? = nil
    
    var body: some View {
        GeometryReader { geo in
            let segmentWidth = geo.size.width / CGFloat(options.count)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.clear)
                
                RoundedRectangle(cornerRadius: 50)
                    .fill(
                        LinearGradient(colors: [.red, .yellow], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: segmentWidth - 12, height: 50 - 7)
                    .offset(x: segmentWidth * CGFloat(preselectedIndex) + 6, y: 0)
                
                HStack() {
                    ForEach(options.indices, id: \.self) { index in
                        Text(options[index])
                            .fontWeight(.medium)
                            .foregroundColor(
                                preselectedIndex == index ? .green : .blue
                            )
                            .frame(width: segmentWidth)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.interactiveSpring(
                                    response: 0.4,
                                    dampingFraction: 0.8,
                                    blendDuration: 0.6
                                )) {
                                    preselectedIndex = index
                                    onSelect?(index)
                                }
                            }
                    }
                }
            }
        }
        .frame(height: 55)
        .clipShape(RoundedRectangle(cornerRadius: 55))
        .overlay {
            RoundedRectangle(cornerRadius: 55)
                .strokeBorder(.yellow, lineWidth: 0.5)
        }
    }
}
