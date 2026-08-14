//
//  View+Extension.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import Foundation
import SwiftUI

extension View {
    func defaultPage() -> some View {
        self
            .background (
                ZStack {
                    
                    Image("img_background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenWidth, height: screenHeight)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)
                    
//                    LinearGradient(colors: [.blackColour,
//                                            .purpleColour.opacity(0.5),
//                                            .darkPurpleColour.opacity(0.5),
//                                            .blackColour,
//                                            .blackColour,
//                                            .secondPurpleColour.opacity(0.5)],
//                                   startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea(.all)
            )
            .navigationBarBackButtonHidden(true)
            .foregroundColor(.whiteColour)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func shimmer() -> some View {
        self
            .background(
                Color.gray.opacity(0.4)
                    .modifier(ShimmerModifier())
            )
    }
}
