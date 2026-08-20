//
//  RotateImage.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//
import SwiftUI
import Photos

struct RotateImage: View {
    @StateObject var viewModel: RotateViewModel
    @State private var showAddImagesSheet = false
    @State private var isGeneratingPDF = false
    @State private var showShareSheet = false
    @State private var showRenameAlert = false
    @State private var userInput = "Document_\(Int(Date().timeIntervalSince1970)).pdf"
    
    var onConvert: (([PHAsset]) -> Void)? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "IMAGE_TO_PDF")

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.selectedAssets, id: \.localIdentifier) { asset in
                            RotateAssetCard(asset: asset, viewModel: viewModel)
                        }

                        AddImagesCard {
                            showAddImagesSheet = true
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                }

                DefaultDesign.FullScreenButton(name: "CONVERT_TO_PDF", onClick: {
                    self.showRenameAlert = true
                })
                .disabled(viewModel.selectedAssets.isEmpty)
            }
            .padding(.horizontal, 16)

            if isGeneratingPDF {
                ProgressOverlay()
            }
        }
        .defaultPage()
        .sheet(isPresented: $showAddImagesSheet) {
            PhotoPickerView { newAssets in
                viewModel.addAssets(newAssets)
            }
        }
        .alert("ADD_PDF_NAME".localized(), isPresented: $showRenameAlert) {
            TextField("ASSIGNMENT.PDF", text: $userInput)
                .textInputAutocapitalization(.words)
            
            Button("SAVE".localized()) {
                generatePDF(name: userInput)
            }
            .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            Button("CANCEL".localized(), role: .cancel) { }
        }
    }

    private func generatePDF(name: String) {
        var finalName = name
        
        if finalName.lowercased().hasSuffix(".pdf") == false {
            finalName += ".pdf"
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(finalName)
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            Toast.shared.show(message: "PDF_WITN_NAME_EXIST".localized(), type: .error)
            return
        }
        
        isGeneratingPDF = true
        
        viewModel.generateFinalPDF(fileName: finalName) { url, stats in
            isGeneratingPDF = false
            if url != nil {
                Router.shared.push(.pdfCreated(url: url, images: viewModel.selectedAssets))
                onConvert?(viewModel.selectedAssets)
            }
        }
    }
}

// MARK: - One image card: thumbnail (rotated live) + filename/date/size overlay + rotate & remove buttons
struct RotateAssetCard: View {
    let asset: PHAsset
    @ObservedObject var viewModel: RotateViewModel

    @State private var thumbnail: UIImage?
    @State private var filename: String = "IMG_0000.jpg"
    @State private var subtitle: String = ""

    var cardWidth: CGFloat {
        return (screenWidth-40)/2
    }
    
    var cardHeight: CGFloat {
        return cardWidth*1.2
    }

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .rotationEffect(.degrees(Double(viewModel.rotationAngle(for: asset))))
                        .frame(width: cardWidth, height: cardHeight, alignment: .center)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight)
            .clipped()

            LinearGradient(
                colors: [Color.black.opacity(0.7), Color.black.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 56)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(filename)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                HStack(spacing: 6) {
                    Button {
                        viewModel.rotate(asset)
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 22, height: 22)
                            .background(Circle().fill(Color.white))
                    }

                    Button {
                        viewModel.remove(asset)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black)
                            .frame(width: 22, height: 22)
                            .background(Circle().fill(Color.white))
                    }
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.black)
        .cornerRadius(14)
        .onAppear {
            viewModel.requestThumbnail(for: asset, size: CGSize(width: 300, height: 300)) { image in
                self.thumbnail = image
            }
            viewModel.requestMetadata(for: asset) { name, sub in
                self.filename = name
                self.subtitle = sub
            }
        }
    }
}

// MARK: - "Add Images" tile, same grid size as the photo cards
struct AddImagesCard: View {
    var onTap: () -> Void
    
    var cardWidth: CGFloat {
        return (screenWidth-40)/2
    }
    
    var cardHeight: CGFloat {
        return cardWidth*1.2
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                VStack(spacing: 4) {
                    VStack {
                        Image("ic_add_more_photo")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.topTobottomGradient)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .padding(10)
                    .background(.whiteColour)
                    .cornerRadius(30)
                    
                    Text("ADD_IMAGE".localized())
                        .font(.caption)
                        .foregroundColor(.whiteColour)
                }
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(width: cardWidth, height: cardHeight)
            .background(Color.white.opacity(0.06))
            .cornerRadius(14)
        }
    }
}

#Preview {
    RotateImage(viewModel: RotateViewModel())
}
