//
//  Shimer.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 06/08/26.
//

import Foundation
import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var offset: CGFloat = -200

        func body(content: Content) -> some View {
            content
                .overlay(
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 50, height: geo.size.height * 2)
                            .blur(radius: 10)
                            .rotationEffect(.degrees(20))
                            .offset(x: offset)
                            .onAppear {
                                withAnimation(
                                    Animation.linear(duration: 1.4)
                                        .repeatForever(autoreverses: false)
                                ) {
                                    offset = geo.size.width + 200
                                }
                            }
                    }
                )
                .mask(content)
        }
}
