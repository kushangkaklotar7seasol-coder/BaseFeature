//
//  RectntPDFScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 19/08/26.
//

import SwiftUI

struct RectntPDFScreen: View {
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "RECENT_FILE")
                
                AllPDFView(isShowHeader: false, lastPDFDeleted: {
                    Router.shared.pop()
                })
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    RectntPDFScreen()
}
