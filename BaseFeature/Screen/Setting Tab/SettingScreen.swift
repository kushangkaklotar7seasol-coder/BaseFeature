//
//  SettingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct SettingScreen: View {
    @StateObject var viewModel = SettingViewModel()
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "SETTING", showBackbutton: false)
                
                ScrollView(showsIndicators: false) {
                    Image("ic_setting_top")
                        .resizable()
                        .frame(width: 200, height: 148, alignment: .center)
                    
                    Text("SETTING_INFO".localized())
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.settingItem.indices, id: \.self) { index in
                            let item = viewModel.settingItem[index]
                            
                            Button {
                                viewModel.onSelect(item.id)
                            } label: {
                                VStack(spacing: 0) {
                                    if index != 0 {
                                        ZStack { }
                                            .frame(height: 1)
                                            .frame(maxWidth: .infinity)
                                            .background(.whiteColour.opacity(0.06))
                                    }
                                    
                                    HStack {
                                        Image(item.value)
                                            .resizable()
                                            .frame(width: 40, height: 40, alignment: .center)
                                            .padding(12)
                                        
                                        Text(item.name.localized())
                                        
                                        Spacer()
                                        
                                        Image("ic_arrow_right")
                                            .resizable()
                                            .frame(width: 15, height: 15, alignment: .center)
                                            .padding()
                                    }
                                }
                            }
//                            
//                            .onTapGesture {
//                                
//                            }
                        }
                    }
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 16)
            .id(localization.selectedLanguage)
        }
        .defaultPage()
    }
}

#Preview {
    SettingScreen()
}
