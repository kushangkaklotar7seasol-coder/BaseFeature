//
//  StorageOverviewScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import SwiftUI
// MARK: - Data Model
struct StorageItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let sizeText: String
    let progress: Double // Value between 0.0 and 1.0
    let gradientColors: [Color]
}

struct StorageOverviewScreen: View {
    @State private var progress: Double = 0.77
    @StateObject var storageManager = StorageManager()
    
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
                
                ZStack {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Section Title
                        Text("Storage Details")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                        
                        // Storage Card Container
                        VStack(spacing: 20) {
                            ForEach(storageManager.storageInfo, id: \.id) { info in
                                storageRowView(item: info)
                            }
                        }
                        .padding(20)
                        .background(Color("#1A1528")) // Inner card background
                        .cornerRadius(20)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
    
    @ViewBuilder
        private func storageRowView(item: StrogeInfo) -> some View {
            HStack(spacing: 16) {
                
                // Icon with Gradient Background
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(item.image)
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                }
                
                // Title, Size & Custom Progress Bar
                VStack(spacing: 8) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("item.sizeText")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                    
                    // Custom Progress Bar with Gradient
//                    GeometryReader { geometry in
//                        ZStack(alignment: .leading) {
//                            // Background Track
//                            Capsule()
//                                .fill(Color.white.opacity(0.1))
//                                .frame(height: 4)
//                            
//                            // Active Progress Track
//                            Capsule()
//                                .fill(
//                                    LinearGradient(
//                                        colors: item.gradientColors,
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .frame(width: geometry.size.width * CGFloat(item.progress), height: 4)
//                        }
//                    }
                    .frame(height: 4)
                }
            }
        }
}

#Preview {
    StorageOverviewScreen()
}
