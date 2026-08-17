//
//  SelectImageScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI
import Photos
import PhotosUI

struct SelectImageScreen: View {
    @StateObject private var photoManager = PhotoLibraryManager()
    @State private var generatedPDFURL: URL?
    @State private var isGeneratingPDF = false
    @State private var showShareSheet = false
 
    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
 
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DefaultDesign.Header(name: "Image to PDF")
                    .padding(.horizontal, 16)
 
                content
            }
 
            if isGeneratingPDF {
                ProgressOverlay()
            }
        }
        .defaultPage()
        .onAppear {
            photoManager.checkAuthorization()
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = generatedPDFURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
 
    // MARK: - Content depending on access state
    @ViewBuilder
    private var content: some View {
        switch photoManager.accessState {
        case .notDetermined:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
 
        case .denied, .restricted:
            deniedAccessView
 
        case .authorized, .limited:
            // limited access -> whatever photos were granted are still fetched & shown
            photoGridView
        }
    }
 
    private var deniedAccessView: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("Photo access denied")
                .font(.headline)
                .foregroundColor(.white)
            Text("Please allow photo access from Settings to select images.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
 
    private var photoGridView: some View {
        VStack(spacing: 0) {
 
            if photoManager.accessState == .limited {
                HStack {
                    Button("Manage Access") {
                        if let root = UIApplication.rootViewController() {
                            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: root)
                        }
                    }
                    .font(.footnote)
                    .foregroundColor(.purple)
 
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
 
            if photoManager.isLoading {
                Spacer()
                ProgressView("Loading photos...")
                    .tint(.white)
                    .foregroundColor(.white)
                Spacer()
            } else {
                // Item size is computed from the global screenWidth, not a GeometryReader.
                // Computing it per-cell (with a GeometryReader inside each thumbnail)
                // caused cells to reflow as thumbnails loaded async, which shifted the
                // real hit-test area after the user had already started tapping —
                // that's what was causing the neighbouring/below image to get selected.
                let horizontalPadding: CGFloat = 16
                let cellSpacing: CGFloat = 4
                let columnsCount: CGFloat = 3
                let itemSize = (screenWidth - (horizontalPadding * 2) - (cellSpacing * (columnsCount - 1))) / columnsCount
 
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(photoManager.groupedAssets) { group in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(formattedDate(group.date))
                                        .font(.subheadline.bold())
                                        .foregroundColor(.white)
 
                                    Spacer()
 
                                    // Select all now applies to THIS date's photos only
                                    Button(photoManager.isAllSelected(in: group) ? "Deselect all" : "Select all") {
                                        photoManager.toggleSelectAll(for: group)
                                    }
                                    .font(.footnote.bold())
                                    .foregroundColor(.lightPurple)
                                }
                                .padding(.horizontal, 16)
 
                                LazyVGrid(columns: columns, spacing: cellSpacing) {
                                    ForEach(group.assets, id: \.localIdentifier) { asset in
                                        PhotoThumbnailView(
                                            asset: asset,
                                            itemSize: itemSize,
                                            isSelected: photoManager.isSelected(asset),
                                            photoManager: photoManager
                                        )
                                        .id(asset.localIdentifier)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            photoManager.toggleSelection(asset)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.bottom, 140)
                }
            }
 
            bottomBar
        }
    }
 
    private var bottomBar: some View {
        VStack(spacing: 12) {
            if !photoManager.selectedAssets.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(photoManager.selectedAssets, id: \.localIdentifier) { asset in
                            SelectedThumbnailView(asset: asset, photoManager: photoManager)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
 
            HStack {
                Text("\(photoManager.selectedAssets.count) Selected")
                    .foregroundColor(.whiteColour)
                    .font(.subheadline)
 
                Spacer()
 
                Button {
//                    generatePDF()
                    Router.shared.push(.arrangeImage(images: photoManager.selectedAssets))
                } label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(photoManager.selectedAssets.isEmpty ? .grayGradient : .leftTorightGradient)
                        .cornerRadius(10)
                }
                .disabled(photoManager.selectedAssets.isEmpty)
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.4))
    }
 
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
 
    // MARK: - Continue -> build PDF from selected photos, in selection order
    private func generatePDF() {
        isGeneratingPDF = true
 
        let selected = photoManager.selectedAssets
        var indexedImages: [Int: UIImage] = [:]
        let group = DispatchGroup()
 
        for (index, asset) in selected.enumerated() {
            group.enter()
            photoManager.requestFullImage(for: asset) { image in
                if let image {
                    indexedImages[index] = image
                }
                group.leave()
            }
        }
 
        group.notify(queue: .main) {
            let orderedImages = (0..<selected.count).compactMap { indexedImages[$0] }
 
            if let url = PDFGenerator.generatePDF(from: orderedImages) {
                self.generatedPDFURL = url
                self.showShareSheet = true
            }
            self.isGeneratingPDF = false
        }
    }
}
 
// MARK: - Thumbnail cell in grid
struct PhotoThumbnailView: View {
    let asset: PHAsset
    let itemSize: CGFloat
    let isSelected: Bool
    @ObservedObject var photoManager: PhotoLibraryManager
    @State private var thumbnail: UIImage?
 
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: itemSize, height: itemSize)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: itemSize, height: itemSize)
            }
            
            ZStack {
                Circle()
                    .fill(isSelected ? .leftTorightGradient : LinearGradient(colors: [.clear], startPoint: .top, endPoint: .bottom))
                    .frame(width: 22, height: 22)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(6)
        }
        .frame(width: itemSize, height: itemSize)
        .cornerRadius(4)
//        .overlay(
//            RoundedRectangle(cornerRadius: 4)
//                .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
//        )
        .onAppear {
            photoManager.requestThumbnail(for: asset, size: CGSize(width: itemSize * 2, height: itemSize * 2)) { image in
                self.thumbnail = image
            }
        }
    }
}
 
// MARK: - Bottom horizontal strip of selected photos
struct SelectedThumbnailView: View {
    let asset: PHAsset
    @ObservedObject var photoManager: PhotoLibraryManager
    @State private var thumbnail: UIImage?
 
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(6)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(.grayColour)
                    })
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .cornerRadius(6)
            }
 
            Button {
                photoManager.removeFromSelection(asset)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .offset(x: 4, y: -4)
        }
        .frame(width: 70, height: 70)
        .onAppear {
            photoManager.requestThumbnail(for: asset, size: CGSize(width: 120, height: 120)) { image in
                self.thumbnail = image
            }
        }
    }
}
 
struct ProgressOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Creating PDF...")
                        .foregroundColor(.white)
                }
            .padding(24)
            .background(Color.black.opacity(0.8))
            .cornerRadius(12)
        }
    }
}
 
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
 
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
 
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
 
extension UIApplication {
    static func rootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return nil }
        return window.rootViewController
    }
}
 
#Preview {
    SelectImageScreen()
}
 
