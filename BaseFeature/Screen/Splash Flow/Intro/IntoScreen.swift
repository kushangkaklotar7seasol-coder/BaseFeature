//
//  IntoScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct IntoScreen: View {
    @StateObject var viewModel = IntroViewModel()
    @State var scrollPosition: Int? = 0
    @State var selectedIndex: Int = 0
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        let item = viewModel.information[index]
                        if Device.isiPadLandscape {
                            HStack {
                                Image(item.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth/2, height: screenHeight)
                                    .clipped()
                                    .id(index)
                                
                                Spacer()
                                
                                VStack {
                                    Text(viewModel.information[selectedIndex].name.localized())
                                        .foregroundColor(.whiteColour)
                                        .font(.system(size: 34, weight: .bold))
                                    + Text(" ")
                                    + Text("\(viewModel.information[selectedIndex].name2.localized())")
                                        .foregroundColor(.lightPurple)
                                        .font(.system(size: 34, weight: .bold))
                                        
                                    Text(viewModel.information[selectedIndex].info.localized())
                                        .font(.system(size: 20, weight: .regular))
                                        .foregroundColor(.grayColour)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 10)
                                }
                                
                                Spacer()
                            }
                            .frame(width: screenWidth, height: screenHeight)
                        } else {
                            Image(item.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth,
                                       height: screenHeight)
                                .clipped()
                                .id(index)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .ignoresSafeArea()
            .id(refreshID)
            .onChange(of: scrollPosition) { _, newValue in
                if let newValue {
                    selectedIndex = newValue
                }
            }
            
            // MARK: Content
            VStack {
                if  selectedIndex == viewModel.information.count - 1 {
                    ZStack {
                        Text("DID_YOU_NOW".localized())
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.whiteColour)
                        + Text(" ")
                        + Text("DID_YOU_NOW2".localized())
                            .foregroundColor(.lightPurple)
                            .font(.system(size: 32, weight: .bold))
                    }
                    .padding()
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                if !Device.isiPadLandscape {
                    Text(viewModel.information[selectedIndex].name.localized())
                        .foregroundColor(.whiteColour)
                        .font(.system(size: 30, weight: .bold))
                    + Text(" ")
                    + Text("\(viewModel.information[selectedIndex].name2.localized())")
                        .foregroundColor(.lightPurple)
                        .font(.system(size: 30, weight: .bold))
                    
                    
                    Text(viewModel.information[selectedIndex].info.localized())
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.grayColour)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                }
                
                HStack(spacing: 8) {
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == selectedIndex ? .leftTorightGradient : .grayGradient)
                            .frame(width: index == selectedIndex ? 16 : 8, height: 8)
                            .animation(.easeInOut, value: selectedIndex)
                    }
                }
                .padding(.bottom, 24)
                
                DefaultDesign.FullScreenButton(name: selectedIndex == viewModel.information.count - 1 ? "GET_STATED" : "NEXT") {
                    if selectedIndex < viewModel.information.count - 1 {
                        selectedIndex += 1
                        withAnimation(.easeInOut(duration: 0.35)) {
                            scrollPosition = selectedIndex
                        }
                    } else {
                        UserdefaultManager.shared.saveIntro(0)
                        Router.shared.updateRoot(.tab)
                    }
                }
                .padding(.bottom,40)
            }
            .padding(.horizontal,16)
            .id(refreshID)
        }
        .defaultPage()
        .background(.blackColour)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
}

#Preview {
    IntoScreen()
}
