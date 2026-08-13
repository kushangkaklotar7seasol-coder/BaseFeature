//
//  HomeScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var storageManager = StorageManager()
    
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
                    Text("All")
                        .foregroundColor(.whiteColour)
                        .font(.system(size: 30, weight: .bold))
                        
                   + Text(" Tools")
                        .foregroundColor(.lightPurple)
                        .font(.system(size: 30, weight: .bold))
                 
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    ZStack {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Storage")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.whiteColour)
                                    
                                    Text("\(storageManager.totalSpace) Total")
                                        .font(.system(size: 14, weight: .regular))
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
                                    
                                    HStack(spacing: 0) {
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
                                                    .font(.system(size: 12, weight: .semibold))
                                            }
                                        }
                                        
                                        Spacer()
                                        
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
                                                    .font(.system(size: 12, weight: .semibold))
                                            }
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
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
                            }
                            .padding(.horizontal, 12)
                            .padding(.bottom)
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
                    
                    HStack() {
                        Text("Quick Tools")
                            .font(.system(size: 18, weight: .bold))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    
                    var toolwidth: CGFloat {
                        return (screenWidth-36)/2
                    }
                    
                    LazyVGrid(columns: columns) {
                        ForEach(0...3, id: \.self) { person in
                            ZStack {
                                VStack(alignment: .leading) {
                                    ZStack { }
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .background()
                                        .cornerRadius(25)
                                    
                                    Text("Goal Tracker")
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text("Set goals, track progress and achieve more.")
                                        .font(.system(size: 12, weight: .regular))
                                        .padding(.top, 1)
                                }
                                .padding(8)
                            }
                            .frame(width: toolwidth, height: 130, alignment: .center)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.bottom)
                }
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    HomeScreen()
}

struct CircularProgressView: View {
    var progress: Double
    var lineWidth: CGFloat = 18

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
                .frame(width: 28, height: 28, alignment: .center)
            
            Text(info.name)
                .font(.system(size: 14, weight: .semibold))
                .padding(.top, 2)
            
            Text(info.storage)
                .font(.system(size: 12, weight: .regular))
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.grayColour.opacity(0.5))
                    .frame(height: 8)
                    .cornerRadius(8)
                
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.lightPurple, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: info.percent, height: 8)
                    .cornerRadius(8)
            }
            .frame(height: 8)
            .cornerRadius(8)
        }
    }
    .padding(6)
    .frame(maxWidth: .infinity, minHeight: 130)
    .background(.whiteColour.opacity(0.08))
    .cornerRadius(12)
}
