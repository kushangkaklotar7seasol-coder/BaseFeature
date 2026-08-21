//
//  HomeScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI
import Photos

struct HomeScreen: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var storageManager = StorageManager()
    @EnvironmentObject var localization: LocalizationManager
    @State private var refreshID = UUID()
    
    var columns: [GridItem] {
        let count = Device.isIpad ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var storageColumns: [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("All".localized())
                        .foregroundColor(.whiteColour)
                        .font(.system(size: 30, weight: .bold))
                    + Text(" ")
                    + Text("TOOLS".localized())
                        .foregroundColor(.lightPurple)
                        .font(.system(size: 30, weight: .bold))
                 
                    Spacer()
                }
                .id(localization.selectedLanguage)
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("STORAGE".localized())
                                        .font(.system(size: Device.isIpad ? 26 : 20, weight: .bold))
                                        .foregroundColor(.whiteColour)
                                    
                                    let total = "TOTAL".localized()
                                    Text("\(storageManager.totalSpace) \(total)")
                                        .font(.system(size: Device.isIpad ? 20 : 14, weight: .regular))
                                        .foregroundColor(.grayColour)
                                }
                                
                                Spacer()
                                
                                Image("ic_right_arrow")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .padding(10)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 30)
                                            .strokeBorder(.whiteColour.opacity(0.2))
                                    }
                            }
                            .padding(.horizontal, 14)
                            .padding(.top, 10)
                            
                            HStack(spacing: 10) {
                                VStack {
                                    CircularProgressView(progress: storageManager.usedStoragePercent)
                                        .frame(maxWidth: Device.isiPadLandscape ? screenWidth/3 : .infinity)
                                        .id(refreshID)
                                        .overlay {
                                            VStack {
                                                Text(String(format: "%.1f%%", storageManager.usedStoragePercent))
                                                    .font(.system(size: Device.isIpad ? 32 : 22, weight: .bold))
                                                
                                                Text("USED".localized())
                                                    .font(.system(size: Device.isIpad ? 24 : 12, weight: .semibold))
                                                    .foregroundColor(.whiteColour)
                                            }
                                        }
                                    
                                    HStack(spacing: 0) {
                                        
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
                                                    .font(.system(size: Device.isIpad ? 24 : 12, weight: .semibold))
                                            }
                                        }
                                        
                                        Spacer()
                                            .frame(maxWidth: Device.isIpad ? 50 : 10)
                                        
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
                                                    .font(.system(size: Device.isIpad ? 24 : 12, weight: .semibold))
                                            }
                                        }
                                        
                                        //} else {
                                        //  deniedAccessView
                                        //}
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                                if storageManager.photoStatus == .authorized || storageManager.photoStatus == .limited {
                                    ZStack {
                                        VStack(spacing: 5) {
                                            // Pehla 2 items - 2 column grid
                                            LazyVGrid(columns: storageColumns, spacing: 5) {
                                                ForEach(storageManager.storageInfo.prefix(2), id: \.id) { info in
                                                    storageCard(info: info)
                                                }
                                            }
                                            
                                            // 3rd item - full width
                                            if let lastItem = storageManager.storageInfo.dropFirst(2).first {
                                                storageCard(info: lastItem)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: (screenWidth-60)/2)
                                } else {
                                    deniedAccessView
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom)
                            
                            if storageManager.photoStatus == .limited {
                                limitedAccessView
                                    .padding(.horizontal, 12)
                                    .padding(.bottom)
                            }
                        }
                    }
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(.whiteColour.opacity(0.2))
                    }
                    .onTapGesture {
                        Router.shared.push(.storageOverview)
                    }
                    .id(localization.selectedLanguage)
                    
                    HStack() {
                        Text("QUICK_TOOL".localized())
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .id(localization.selectedLanguage)
                    
                    var toolwidth: CGFloat {
                        if Device.isIpad {
                            return (screenWidth-36)/4
                        } else {
                            return (screenWidth-36)/2
                        }
                    }
                    
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.quickTool, id: \.id) { tool in
                            ZStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    ZStack {
                                        Image(tool.image)
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: .center)
                                    }
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .cornerRadius(25)
                                    
                                    Text(tool.name.localized())
                                        .font(.system(size: 14, weight: .semibold))
                                        .lineLimit(1)
                                    
                                    Text(tool.info.localized())
                                        .font(.system(size: 12, weight: .regular))
                                        .padding(.top, 1)
                                        .lineLimit(2)
                                        .foregroundColor(.grayColour)
                                }
                                .padding(8)
                                .frame(width: toolwidth, height: 130, alignment: .topLeading)
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        
                                        Image("ic_right_arrow")
                                            .resizable()
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .padding(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .strokeBorder(.whiteColour.opacity(0.2))
                                            }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(8)
                            }
                            .frame(width: toolwidth, height: 130, alignment: .center)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(12)
                            .onTapGesture {
                                viewModel.onQuickTool(tool)
                            }
                        }
                    }
                    .padding(.bottom)
                    .id(localization.selectedLanguage)
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
            Divider()
            
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
}

#Preview {
    HomeScreen()
}

struct CircularProgressView: View {
    var progress: Double
    var lineWidth: CGFloat = Device.isIpad ? 26 : 18

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .strongPrimeGradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)

        }
        .padding()
    }
}

@ViewBuilder
func storageCard(info: StrogeInfo) -> some View {
    ZStack {
        VStack(alignment: .leading) {
            Image(info.image)
                .resizable()
                .scaledToFill()
                .frame(width: Device.isIpad ? 32 : 28, height:Device.isIpad ? 32 : 28, alignment: .center)
            
            Text(info.name.localized())
                .font(.system(size: Device.isIpad ? 18 : 14, weight: .semibold))
                .padding(.top, 2)
            
            Text(info.storage)
                .font(.system(size: Device.isIpad ? 16: 12, weight: .regular))
              
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.grayColour.opacity(0.5))
 
                    Capsule()
                        .fill(info.gradient)
                        .frame(width: geo.size.width * CGFloat(info.percent / 100))
                }
            }
            .frame(height: Device.isIpad ? 10 : 8)
        }
    }
    .padding(6)
    .frame(maxWidth: .infinity, minHeight: 130)
    .background(.iconBackgroundColour)
    .cornerRadius(12)
    .overlay {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(.whiteColour.opacity(0.2))
    }
}
