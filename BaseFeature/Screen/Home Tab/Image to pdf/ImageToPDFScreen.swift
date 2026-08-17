//
//  ImageToPDFScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI

struct ImageToPDFScreen: View {
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Image to PDF")
                
                Image("ic_image_to_pdf")
                
                Text("Convert Images to PDF")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Text("Create high quality PDF from your images in seconds.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.grayColour)
                    .font(.system(size: 14, weight: .regular))
                
                Button {
                    Router.shared.push(.selectImage)
                } label: {
                    HStack(spacing: 5) {
                        Image("ic_plus")
                            .resizable()
                            .frame(width: 15, height: 15, alignment: .center)
                        
                        Text("Select Images")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.whiteColour)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 44)
                    .background(.leftTorightGradient)
                    .cornerRadius(10)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
}

#Preview {
    ImageToPDFScreen()
}
