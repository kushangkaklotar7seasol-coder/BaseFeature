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
    @State private var refreshID = UUID()
    
    var body: some View {
        
        var lottieSize: CGFloat {
            if Device.isiPadPortrait {
                return screenWidth/2
            } else if Device.isiPadLandscape {
                return screenWidth/3
            } else {
                return screenWidth-100
            }
        }
        
        ZStack {
            VStack {
                LottieView(animation: .named("pdf_loading_lottie"))
                    .looping()
                    .resizable()
                    .frame(width: lottieSize, height: lottieSize)
                    .id(refreshID)
                
                VStack(spacing: 16) {
                    Text("PDF_CREATED_SUCCESS".localized())
                        .font(.system(size: 24, weight: .semibold))
                    
                    VStack(spacing: 5) {
                        let image = "IMAGES".localized()
                        let pages = "PAGES".localized()
                        Text("\(selectedAssets.count) \(image) • \(pdfInformation?.totalPages ?? 0) \(pages)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.grayColour)
                        
                        Text(pdfInformation?.sizeFormatted ?? "0")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.grayColour)
                    }
                    
                    DefaultDesign.FullScreenButton(name: "OPEN_PDF", onClick: {
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
                                
                                Text("SHARE_PDF".localized())
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.grayColour)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.whiteColour.opacity(0.08))
                            .cornerRadius(8)
                        }
                        
                        Button {
                            Router.shared.push(.recentpdf)
                        } label: {
                            HStack {
                                Text("SEE_ALL_PDF".localized())
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
                        
                        Text("BACK_TO_HOME".localized())
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
        .onAppear() {
            isSwipeBackenable = false
            if let url = self.generatedPDFURL {
                self.pdfInformation = PDFGenerator.getPDFSummary(pdfURL: url)
            }
        }
        .onDisappear() {
            isSwipeBackenable = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
}

#Preview {
    PDFCreatedScreen()
}
