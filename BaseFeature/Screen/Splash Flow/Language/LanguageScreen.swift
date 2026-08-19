//
//  LanguageScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct LanguageScreen: View {
    @StateObject var viewModel: LanguageViewModel
    @EnvironmentObject var localization: LocalizationManager
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 3 : Device.isiPadLandscape ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "LANGUAGE", showBackbutton: false)
                
                ScrollView(showsIndicators: false) {
                    
                    Text("SELECT_LANGUAGE".localized())
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.whiteColour)
                        .padding(.top, 30)
                    
                    Text("CHOOSE_LANGUAGE".localized())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.grayColour)
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.languages, id: \.id) { language in
                            
                            ZStack(){
                                VStack() {
                                    Image(language.icon)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                    
                                    Text(language.subTitle)
                                        .foregroundColor(.whiteColour)
                                    
                                    Text("\(language.title)")
                                        .foregroundColor(.grayColour)
                                        .font(.system(size: 12))
                                }
                                .padding(14)
                                
                                if viewModel.selectedLanguage?.code == language.code {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            Image("ic_right")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .padding(8)
                                                .background(.topTobottomGradient)
                                                .cornerRadius(12)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.leftTorightGradient, lineWidth: viewModel.selectedLanguage?.code == language.code ? 1 : 0)
                            )
                            .onTapGesture {
                                viewModel.selectedLanguage = language
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .edgesIgnoringSafeArea(.bottom)
                
                DefaultDesign.FullScreenButton(name: "CONTINUE", onClick: {
                    localization.changeLanguage(languageCode: viewModel.selectedLanguage?.code ?? "en")
                    viewModel.onDoneButtonClick()
                })
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .onAppear {
            viewModel.selectedLanguage = UserdefaultManager.shared.getLanguage() ?? LanguageItem(code: "en")
        }
    }
}

#Preview {
    LanguageScreen(viewModel: LanguageViewModel())
}
