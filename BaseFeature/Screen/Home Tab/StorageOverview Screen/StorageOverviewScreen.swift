//
//  StorageOverviewScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import SwiftUI

struct StorageOverviewScreen: View {
    @StateObject var storageManager = StorageManager()
    
    var body: some View {
        
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Storage Overview")
                
                HStack {
                    CircularProgressView(progress: storageManager.usedStoragePercent)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(storageManager.totalSpace) Total")
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
                                
                                Text(storageManager.usedSpace)
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
                                
                                Text(storageManager.freeSpace)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                    }
                }
                
                breakdownSection
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
    
    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Storage Details")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 4)
 
            if storageManager.storageInfo.isEmpty {
                Text("Calculating storage usage…")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.grayColour)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 0) {
                    ForEach(storageManager.storageInfo.indices, id: \.self) { index in
                        let info = storageManager.storageInfo[index]
                        
                        if index != 0 {
                            Divider()
                        }
                        
                        breakdownRow(info: info)
                    }
                }
                .background(.whiteColour.opacity(0.05))
                .cornerRadius(14)
            }
        }
    }
 
    private func breakdownRow(info: StrogeInfo) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(info.image)
                    .resizable()
                    .frame(width: 40, height: 40)
//                    .padding(8)
//                    .background(.whiteColour.opacity(0.08))
//                    .clipShape(Circle())
 
                Text(info.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.whiteColour)
 
                Spacer()
 
                Text(info.storage)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.grayColour)
            }
 
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.whiteColour.opacity(0.12))
 
                    Capsule()
                        .fill(info.gradient)
                        .frame(width: geo.size.width * CGFloat(info.percent / 100))
                }
            }
            .frame(height: 6)
 
            Text(String(format: "%.1f%% of total storage", info.percent))
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.grayColour)
        }
        .padding(14)
//        .background(.whiteColour.opacity(0.05))
//        .cornerRadius(14)
    }
}

#Preview {
    StorageOverviewScreen()
}
