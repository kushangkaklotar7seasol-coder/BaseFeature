//
//  CustomSegmentedControl.swift
//  Movies Guide
//
//  Created by Kushang  on 14/12/25.
//
import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String] = ["MOVIES", "TV SHOW"]
    var onSelect: ((Int) -> Void)? = nil
    
    var icons = ["ic_camara_roal", "ic_camara_series"]
    
    var body: some View {
        HStack(spacing: 24) { // બંને ઓપ્શન વચ્ચેનું સ્પષ્ટ અંતર
            ForEach(options.indices, id: \.self) { index in
                let isSelected = preselectedIndex == index
                
                HStack(spacing: 8) {
                    // Icon
                    Image(icons[index < icons.count ? index : 0])
                        .renderingMode(.template)
                        .foregroundColor(isSelected ? .whiteColour : .grayColour)
                        .font(.system(size: 24, weight: .bold))
                    
                    // Title Text
                    Text(options[index])
                        .font(.system(size: 14, weight: .bold))
                        .tracking(1)
                }
                .foregroundColor(isSelected ? .whiteColour : .grayColour)
                // 🔥 ફક્ત પર્ટીક્યુલર બટન માટેનું Inner Padding
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                // 🔥 બેકગ્રાઉન્ડ ફક્ત ટેક્સ્ટ/આઈકનની સાઈઝ મુજબ જ દેખાશે
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.blueColour, .purpleColour],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                // સ્મૂથ સિલેક્શન ટ્રાન્ઝિશન
                                .matchedGeometryEffect(id: "selectedSegment", in: animationNamespace)
                        }
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(
                        .interactiveSpring(
                            response: 0.35,
                            dampingFraction: 0.8,
                            blendDuration: 0.5
                        )
                    ) {
                        preselectedIndex = index
                        onSelect?(index)
                    }
                }
            }
        }
    }
    @Namespace private var animationNamespace
}
