//
//  Splash.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import SwiftUI

struct Splash: View {
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Hello splash")
                    Spacer()
                }
                Spacer()
            }
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
}
