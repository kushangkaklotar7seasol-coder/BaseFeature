//
//  PDFCreatedScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import SwiftUI
import Lottie
import Photos

struct PDFCreatedScreen: View {
    @State private var showShareSheet = false
    @State private var showPreview = false
    @State var generatedPDFURL: URL?
    @State var pdfInformation: PDFSummary?
    @State var selectedAssets: [PHAsset] = []
    @State private var showSaveToFiles = false
    
    var body: some View {
        ZStack {
            VStack {
                LottieView(animation: .named("pdf_loading_lottie"))
                    .looping()
                    .resizable()
                    .frame(width: screenWidth-100, height: screenWidth-100)
                
                VStack(spacing: 16) {
                    Text("PDF Created Successfully !")
                        .font(.system(size: 24, weight: .semibold))
                    
                    VStack(spacing: 5) {
                        Text("\(selectedAssets.count) Images • \(pdfInformation?.totalPages ?? 0) Pages")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.grayColour)
                        
                        Text(pdfInformation?.sizeFormatted ?? "0")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.grayColour)
                    }
                    
                    DefaultDesign.FullScreenButton(name: "Open PDF", onClick: {
                        self.showPreview = true
                    })
                    
                    HStack() {
                        Button {
                            self.showShareSheet = true
                        } label: {
                            HStack {
                                Image("ic_share_gray")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                
                                Text("Share PDF")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(8)
                        }
                        
                        Button {
                            showSaveToFiles = true
                        } label: {
                            HStack {
                                Image("ic_save_gray")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                
                                Text("Save To Device")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(12)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    Router.shared.popToRoot()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 12, height: 12, alignment: .center)
                        
                        Text("Back To Home")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.grayColour)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .sheet(isPresented: $showShareSheet) {
            if let url = generatedPDFURL {
                ShareSheet(activityItems: [url])
            }
        }
        .fullScreenCover(isPresented: $showPreview, content: {
            if let url = generatedPDFURL {
                PDFPreviewScreen(url: url)
            }
        })
        .sheet(isPresented: $showSaveToFiles) {
            SaveToFilesPicker(url: generatedPDFURL ?? URL(filePath: "")) {
                Toast.shared.show(message: "PDF Save successfully!", type: .success)
                Router.shared.popToRoot()
            }
        }
        .onAppear() {
            isSwipeBackenable = false
            if let url = self.generatedPDFURL {
                self.pdfInformation = PDFGenerator.getPDFSummary(pdfURL: url)
            }
        }
        .onDisappear() {
            isSwipeBackenable = true
        }
    }
}

#Preview {
    PDFCreatedScreen()
}
