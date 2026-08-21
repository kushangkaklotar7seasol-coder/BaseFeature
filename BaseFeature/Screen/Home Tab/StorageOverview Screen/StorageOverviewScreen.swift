//
//  StorageOverviewScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import SwiftUI
import Photos

struct StorageOverviewScreen: View {
    @StateObject var storageManager = StorageManager()
    @State private var refreshID = UUID()
    
    var body: some View {
        
        ZStack {
            VStack {
                DefaultDesign.Header(name: "STORAGE_OVERVIEW".localized())
                
                ScrollView(showsIndicators: false) {
                    HStack {
                        CircularProgressView(progress: storageManager.usedStoragePercent)
                            .frame(maxWidth: Device.isiPadPortrait ? screenHeight/2.5 : Device.isiPadLandscape ? screenWidth/3 : .infinity)
                            .overlay {
                                VStack {
                                    Text(String(format: "%.1f%%", storageManager.usedStoragePercent))
                                        .font(.system(size: Device.isIpad ? 32 : 26, weight: .bold))
                                    
                                    Text("USED".localized())
                                        .font(.system(size: Device.isIpad ? 20 : 12, weight: .semibold))
                                        .foregroundColor(.whiteColour)
                                }
                            }
                            .id(refreshID)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            let total = "TOTAL".localized()
                            Text("\(storageManager.totalSpace) \(total)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.whiteColour)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    DefaultDesign.GradientBullet()
                                    
                                    Text("USED".localized())
                                        .font(.system(size: Device.isIpad ? 18 : 10, weight: .semibold))
                                        .foregroundColor(.grayColour)
                                }
                                
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .clear)
                                    
                                    Text(storageManager.usedSpace)
                                        .font(.system(size: Device.isIpad ? 24 : 14, weight: .semibold))
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .purpleColour.opacity(0.5))
                                    
                                    Text("FREE".localized())
                                        .font(.system(size: Device.isIpad ? 18 : 10, weight: .semibold))
                                        .foregroundColor(.grayColour)
                                }
                                
                                HStack {
                                    DefaultDesign.CustomBullet(Color: .clear)
                                    
                                    Text(storageManager.freeSpace)
                                        .font(.system(size: Device.isIpad ? 24 : 14, weight: .semibold))
                                }
                            }
                        }
                    }
                    
                    if storageManager.photoStatus == .authorized || storageManager.photoStatus == .limited {
                        if storageManager.photoStatus == .limited {
                            limitedAccessView
                        }
                        breakdownSection
                    } else {
                        deniedAccessView
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
    
    private var deniedAccessView: some View {
        VStack(spacing: 16) {
            Text("PHOTO_ACCESS_DENIED".localized())
                .font(.headline)
                .foregroundColor(.white)
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("OPEN_SETTING".localized())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var limitedAccessView: some View {
        VStack {
            HStack(spacing: 16) {
                Text("GIVE_US_FULL_ACCESS".localized())
                    .font(.system(size: 14, weight: .semibold))
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("OPEN_SETTING".localized())
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("STORAGE_DETAIL".localized())
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 4)
 
            if storageManager.storageInfo.isEmpty {
                Text("CALCULATING_STORAGE".localized())
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
 
                Text(info.name.localized())
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
            
            let total = "OF_TOTAL_STORAGE".localized()
            Text(String(format: "%.1f%% \(total)", info.percent))
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
