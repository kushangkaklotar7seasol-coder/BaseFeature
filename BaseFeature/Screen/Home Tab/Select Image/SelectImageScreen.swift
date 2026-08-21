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
    var onComplete: (([PHAsset]) -> Void)?
    @State var isShowPhotoPicker: Bool = false
    @State var selectedItems: [PhotosPickerItem] = []     // ← Array banao (multiple)
    @State private var refreshID = UUID()
    
//    private let columns = [
//        GridItem(.flexible(), spacing: 4),
//        GridItem(.flexible(), spacing: 4),
//        GridItem(.flexible(), spacing: 4)
//    ]
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 5 : Device.isiPadLandscape ? 6 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 4), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DefaultDesign.Header(name: "IMAGE_TO_PDF")
                    .padding(.horizontal, 16)
                
                if photoManager.accessState == .limited {
                    limitedAccessView
                        .padding(.horizontal, 16)
                }
                
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
        .onReceive(NotificationCenter.default.publisher(for: .imagesArranged)) { notification in
            if let arrangedImages = notification.object as? [PHAsset] {
                photoManager.selectedAssets = []
                photoManager.selectedAssets = arrangedImages
            }
        }
//        .sheet(isPresented: $isShowPhotoPicker) {
//            PhotoPickerView { newAssets in
//                photoManager.selectedAssets.append(contentsOf: newAssets)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                    Router.shared.push(.arrangeImage(images: photoManager.selectedAssets))
//                }
//            }
//        }
        .photosPicker(
            isPresented: $isShowPhotoPicker,
            selection: $selectedItems,          // Array binding
            maxSelectionCount: 0,                         // 0 = unlimited
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedItems) { oldValue, newItems in
            guard !newItems.isEmpty else { return }
            
            self.convertToPHAssets(items: newItems)
        }
        
    }
    
    private var limitedAccessView: some View {
        HStack(spacing: 16) {
            Text("GIVE_US_FULL_ACCESS".localized())
                .font(.system(size: 14, weight: .semibold))
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("OPEN_SETTING".localized())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func getPHAssets(
        from items: [PhotosPickerItem],
        completion: (([PHAsset]) -> Void)?
    ) {
        let identifiers = items.compactMap { $0.itemIdentifier }

        print("PhotosPickerItem count:", items.count)
        print("Identifiers:", identifiers)

        guard !identifiers.isEmpty else {
            completion?([])
            return
        }

        let result = PHAsset.fetchAssets(
            withLocalIdentifiers: identifiers,
            options: nil
        )

        print("PHAsset count:", result.count)

        var assets: [PHAsset] = []

        result.enumerateObjects { asset, _, _ in
            print("FOUND:", asset.localIdentifier)
            assets.append(asset)
        }

        completion?(assets)
    }
    
    func convertToPHAssets(items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }
        
        self.getPHAssets(from: items, completion: { photos in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Router.shared.push(.arrangeImage(images: photos))
            }
        })
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
            Text("PHOTO_ACCESS_DENIED".localized())
                .font(.headline)
                .foregroundColor(.white)
            Text("PHOTO_ACCESS_DENIED_INFO".localized())
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("OPEN_SETTING".localized())
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
 
//            if photoManager.accessState == .limited {
//                HStack {
//                    Button("MANAGE_ACCESS") {
//                        if let root = UIApplication.rootViewController() {
//                            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: root)
//                        }
//                    }
//                    .font(.footnote)
//                    .foregroundColor(.purple)
// 
//                    Spacer()
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 8)
//            }
 
            if photoManager.isLoading {
                Spacer()
                ProgressView("LOADING_PHOTOS".localized())
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
                let columnsCount: CGFloat = Device.isiPadPortrait ? 5 : Device.isiPadLandscape ? 6 : 3
                let itemSize = (screenWidth - (horizontalPadding * 2) - (cellSpacing * (columnsCount - 1))) / columnsCount
 
                if !photoManager.groupedAssets.isEmpty {
                    
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
                                        Button(photoManager.isAllSelected(in: group) ? "DISSELECT_ALL".localized() : "SELECT_ALL".localized()) {
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
                    .id(refreshID)
                } else {
                    Spacer()
                    
                    Image("ic_no_favourite")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text("NO_PHOTOS_FOUND".localized())
                        .padding(.top, 15)
                    
                    Spacer()
                }
            }
 
            bottomBar
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
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
                let selected = "SELECTED".localized()
                Text("\(photoManager.selectedAssets.count) \(selected)")
                    .foregroundColor(.whiteColour)
                    .font(.subheadline)
 
                Spacer()
 
                Button {
//                    generatePDF()
                    Router.shared.push(.arrangeImage(images: photoManager.selectedAssets))
                } label: {
                    Text("CONTINUE".localized())
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
                    .frame(width: Device.isIpad ? 90 : 60, height: Device.isIpad ? 90 : 60)
                    .clipped()
                    .cornerRadius(6)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(.grayColour)
                    })
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: Device.isIpad ? 90 : 60, height: Device.isIpad ? 90 : 60)
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
        .frame(width: Device.isIpad ? 100 : 70, height: Device.isIpad ? 100 : 70)
        .onAppear {
            photoManager.requestThumbnail(for: asset, size: CGSize(width: 120, height: 120)) { image in
                self.thumbnail = image
            }
        }
    }
}
 
import SwiftUI

struct ProgressOverlay: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background dimming
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            // Card Container
            VStack(spacing: 20) {
                // Animated Visual Header
                ZStack {
                    // Outer pulsing ring
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.0 : 1.0)
                    
                    // Inner glowing background
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    // Floating Document Icon
                    Image(systemName: "doc.richtext.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.blue)
                        .offset(y: isAnimating ? -4 : 4)
                }
                
                // Text & Subtitle
                VStack(spacing: 6) {
                    Text("GENERATING_PDF".localized())
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("DOC_LAYOUT_COMP".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Sleek Progress Indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.1)
            }
            .padding(.vertical, 28)
            .padding(.horizontal, 32)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
            )
            .padding(40)
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
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
 
