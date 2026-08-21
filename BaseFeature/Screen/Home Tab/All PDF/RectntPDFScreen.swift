//
//  RectntPDFScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 19/08/26.
//

import SwiftUI

struct RectntPDFScreen: View {
    var isSimpleBack: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Button {
                            if isSimpleBack {
                                Router.shared.pop()
                            } else {
                                Router.shared.popToScreen(to: .imageToPDF)
                            }
                            UINavigationController.isSwipeBackenable = true
                        } label: {
                            Image("ic_back")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .center)
                        }
                    }
                    .frame(width: 55)
                    
                    Spacer()
                    
                    Text("RECENT_FILE".localized())
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.whiteColour)
                    
                    Spacer()
                    
                    ZStack { }
                        .frame(width: 55, height: 30, alignment: .center)
                }
                
                AllPDFView(isShowHeader: false, lastPDFDeleted: {
                    Router.shared.pop()
                })
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .onAppear() {
            UINavigationController.isSwipeBackenable = isSimpleBack
        }
    }
}

#Preview {
    RectntPDFScreen()
}
