//
//  Splash.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI
import Lottie

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            Image("img_splash")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("app_icon")
                    .resizable()
                    .frame(width: 110, height: 110, alignment: .center)
                
                Text("Cinevora")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.whiteColour)
            }
            
            
            VStack {
                Spacer()
                
                LottieView(animation: .named("loading_lottie"))
                    .looping()
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .padding(.vertical, 50)
        }
        .defaultPage()
        .onAppear() {
            viewModel.webservice_getJSON_api() {}
            
            viewModel.requestTrackingPermission() {
                viewModel.navigationManager()
            }
        }
    }
}

#Preview {
    Splash()
}

class DefaultDesign {
    
    struct Header: View {
        let name: String
        var showBackbutton: Bool = true
        let secondButton: String = ""
        var onSecondButtonClick: (()->Void)?
        
        var body: some View {
            HStack {
                HStack {
                    if showBackbutton {
                        Button {
                            Router.shared.pop()
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .center)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 55)
                
                Spacer()
                
                Text(name.localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Spacer()
                
                ZStack {
                    Button {
                        self.onSecondButtonClick?()
                    } label: {
                        Text(secondButton.localized())
                            .foregroundColor(.lightPurple)
                    }
                }
                .frame(width: 55, height: 30, alignment: .center)
            }
        }
    }
    
    struct FullScreenButton: View {
        let name: String
        var onClick: (()->Void?)
        
        var body: some View {
            Button {
                self.onClick()
            } label: {
                Text(name.localized())
                    .padding()
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.whiteColour)
                    .frame(maxWidth: .infinity)
                    .background(.leftTorightGradient)
                    .cornerRadius(10)
            }
        }
    }
    
    struct GradientBullet: View {
        var body: some View {
            ZStack { }
                .frame(width: 8, height: 8, alignment: .center)
                .background(.strongPrimeGradient)
                .cornerRadius(8)
        }
    }
    
    struct CustomBullet: View {
        let Color: Color
        
        var body: some View {
            ZStack { }
                .frame(width: 8, height: 8, alignment: .center)
                .background(Color)
                .cornerRadius(8)
        }
    }
}
