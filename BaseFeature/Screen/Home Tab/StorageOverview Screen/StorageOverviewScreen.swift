//
//  StorageOverviewScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import SwiftUI

struct StorageOverviewScreen: View {
    @State private var progress: Double = 0.77
    
    var body: some View {
        ZStack {
            VStack {
                
                DefaultDesign.Header(name: "Storage Overview")
                
                HStack {
                    CircularProgressView(progress: progress)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("128 GB Total")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.whiteColour)
                        
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    DefaultDesign.GradientBullet()
                                    
                                    Text("Used")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.grayColour)
                                }
                                
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .clear)
                                    
                                    Text("50 GB")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .purpleColour.opacity(0.5))
                                    
                                    Text("Free")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.grayColour)
                                }
                                
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .clear)
                                    
                                    Text("100 GB")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    StorageOverviewScreen()
}
