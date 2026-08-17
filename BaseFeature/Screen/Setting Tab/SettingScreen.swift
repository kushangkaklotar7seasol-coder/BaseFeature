//
//  SettingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct SettingScreen: View {
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Setting", showBackbutton: false)
                
                ScrollView(showsIndicators: false) {
                    Image("ic_setting_top")
                        .resizable()
                        .frame(width: 200, height: 148, alignment: .center)
                    
                    Text("Your privacy and experience matter to us.")
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.settingItem.indices, id: \.self) { index in
                            let item = viewModel.settingItem[index]
                            
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
                            .onTapGesture {
                                viewModel.onSelect(item.id)
                            }
                        }
                    }
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    SettingScreen()
}
