//
//  ArrangePageViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import Foundation
import Combine
import Photos
import UIKit
import SwiftUI

class ArrangePageViewModel: ObservableObject {
    @Published var selectedAssets: [PHAsset] = []
    @Published var isRemoveMode: Bool = false

    init(selectedAssets: [PHAsset] = []) {
        self.selectedAssets = selectedAssets
    }

    // MARK: - Reorder (index auto-updates because the array order itself changes)
    func move(from source: IndexSet, to destination: Int) {
        selectedAssets.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - Remove
    func remove(at offsets: IndexSet) {
        selectedAssets.remove(atOffsets: offsets)
    }

    func remove(_ asset: PHAsset) {
        selectedAssets.removeAll { $0 == asset }
        if selectedAssets.count <= 0 {
            NotificationCenter.default.post(name: .imagesArranged, object: [])
            Router.shared.pop()
        }
    }

    func toggleRemoveMode() {
        isRemoveMode.toggle()
    }

    // MARK: - Add images (from the "Add Images" bottom sheet picker)
    func addAssets(_ newAssets: [PHAsset]) {
        for asset in newAssets where !selectedAssets.contains(asset) {
            selectedAssets.append(asset)
        }
    }

    // MARK: - Thumbnail loading
    private let imageManager = PHCachingImageManager()

    func requestThumbnail(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }

    // MARK: - Filename + date + file size, shown under each row's thumbnail
    func requestMetadata(for asset: PHAsset, completion: @escaping (_ filename: String, _ subtitle: String) -> Void) {
        let resource = PHAssetResource.assetResources(for: asset).first
        let filename = resource?.originalFilename ?? "IMG_0000.jpg"

        var dateText = ""
        if let date = asset.creationDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            dateText = formatter.string(from: date)
        }

        var sizeText = "--"
        if let fileSize = resource?.value(forKey: "fileSize") as? Int64 {
            sizeText = ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
        }

        let subtitle = [dateText, sizeText].filter { !$0.isEmpty }.joined(separator: " • ")
        completion(filename, subtitle)
    }
}
