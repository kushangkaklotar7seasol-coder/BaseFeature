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
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.information.indices, id: \.self) { index in
                        let item = viewModel.information[index]
                        
                        Image(item.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenWidth,
                                   height: screenHeight)
                            .clipped()
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .ignoresSafeArea()
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
                
                Text(viewModel.information[selectedIndex].name.localized())
                    .foregroundColor(.whiteColour)
                    .font(.system(size: 30, weight: .bold))
                + Text(" ")
                + Text(" \(viewModel.information[selectedIndex].name2.localized())")
                    .foregroundColor(.lightPurple)
                    .font(.system(size: 30, weight: .bold))
                    
                
                Text(viewModel.information[selectedIndex].info.localized())
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.grayColour)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
//                if  selectedIndex == viewModel.information.count - 1 {
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Image("ic_info_empty")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                            
//                            Text("Strings.goodToKnow")
//                                .font(.system(size: 18, weight: .medium))
//                        }
//                        
//                        Text("Strings.goodToKnowInfo")
//                            .font(.system(size: 14))
//                            .foregroundColor(.grayColour)
//                    }
//                    .padding(20)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .cornerRadius(24)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 24)
//                            .strokeBorder(.whiteColour.opacity(0.2))
//                    }
//                    .padding(.bottom, 10)
//                    .padding(.top, 10)
//                }
                
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
        }
        .defaultPage()
        .background(.blackColour)

    }
}

#Preview {
    IntoScreen()
}
