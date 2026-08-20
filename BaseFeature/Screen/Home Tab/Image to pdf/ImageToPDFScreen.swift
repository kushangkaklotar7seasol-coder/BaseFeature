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
                DefaultDesign.Header(name: "IMAGE_TO_PDF")
                
                Image("ic_image_to_pdf")
                
                Text("CONVERT_IMAGE_TO_PDF".localized())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Text("CONVERT_IMAGE_TO_PDF_INFO".localized())
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
                        
                        Text("SELECT_IMAGE".localized())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.whiteColour)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 44)
                    .background(.leftTorightGradient)
                    .cornerRadius(10)
                }
                .padding(.top)
                
//                if !self.fetchSavedPDFs().isEmpty {
//                    DefaultDesign.SectionHeader(name: "RECENT_FILE", onClick: {
//                        Router.shared.push(.recentpdf)
//                    })
//                    .padding(.top, 10)
                    
                    AllPDFView()
//                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
    }
    
    func fetchSavedPDFs() -> [URL] {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }

        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [.creationDateKey],
                options: .skipsHiddenFiles
            )

            let pdfFiles = files.filter { $0.pathExtension.lowercased() == "pdf" }

            // Newest first
            return pdfFiles.sorted { lhs, rhs in
                let lhsDate = (try? lhs.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? .distantPast
                let rhsDate = (try? rhs.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? .distantPast
                return lhsDate > rhsDate
            }
        } catch {
            print("Failed to list saved PDFs: \(error)")
            return []
        }
    }
}

#Preview {
    ImageToPDFScreen()
}

