//
//  RotateViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 18/08/26.
//

import Foundation
import Combine
import Photos
import UIKit

class RotateViewModel: ObservableObject {
    @Published var selectedAssets: [PHAsset] = []
    
    /// Rotation currently applied to each asset, keyed by localIdentifier (0 / 90 / 180 / 270)
    @Published var rotationAngles: [String: Int] = [:]
    
    // This array comes in from the previous screen — we never fetch photos ourselves here.
    // New photos only get added when the user explicitly taps "Add Images".
    init(selectedAssets: [PHAsset] = []) {
        self.selectedAssets = selectedAssets
    }
    
    private let imageManager = PHCachingImageManager()
    
    // MARK: - Thumbnail + metadata (same approach as the earlier screens)
    func requestThumbnail(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
    
    func requestFullImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { image, _ in
            completion(image)
        }
    }
    
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
    
    // MARK: - Rotate (only the tapped image rotates, others are untouched)
    func rotate(_ asset: PHAsset) {
        let id = asset.localIdentifier
        let current = rotationAngles[id] ?? 0
        rotationAngles[id] = (current + 90) % 360
    }
    
    func rotationAngle(for asset: PHAsset) -> Int {
        rotationAngles[asset.localIdentifier] ?? 0
    }
    
    // MARK: - Remove (pulls the asset out of the array)
    func remove(_ asset: PHAsset) {
        selectedAssets.removeAll { $0 == asset }
        rotationAngles.removeValue(forKey: asset.localIdentifier)
    }
    
    // MARK: - Add (from the "Add Images" picker sheet)
    func addAssets(_ newAssets: [PHAsset]) {
        for asset in newAssets where !selectedAssets.contains(asset) {
            selectedAssets.append(asset)
        }
    }
    
    // MARK: - Convert To PDF tapped
    // Fetches each asset's full-size image, applies whatever rotation the user chose,
    // then builds one PDF (in array order) using PDFGenerator.
    func generateFinalPDF(fileName: String? = nil, completion: @escaping (URL?, PDFGenerator.PDFStats?) -> Void) {
            let assets = selectedAssets
            var indexedImages: [Int: UIImage] = [:]
            let group = DispatchGroup()
     
            for (index, asset) in assets.enumerated() {
                group.enter()
                requestFullImage(for: asset) { [weak self] image in
                    defer { group.leave() }
                    guard let self, let image else { return }
                    let angle = self.rotationAngle(for: asset)
                    indexedImages[index] = image.rotated(byDegrees: angle)
                }
            }
     
            group.notify(queue: .main) {
                let orderedImages = (0..<assets.count).compactMap { indexedImages[$0] }
     
                guard let tempURL = PDFGenerator.generatePDF(from: orderedImages) else {
                    completion(nil, nil)
                    return
                }
     
                // Move it out of the temp folder into Documents (permanent storage)
                let finalName = fileName ?? "Document_\(Int(Date().timeIntervalSince1970)).pdf"
                guard let savedURL = savePDFToDocuments(from: tempURL, fileName: finalName) else {
                    completion(nil, nil)
                    return
                }
     
                let stats = PDFGenerator.stats(for: savedURL)
                completion(savedURL, stats)
            }
        }
}
  
 // MARK: - Rotates pixel data itself (not just a visual transform), so the rotation is baked into the PDF
 extension UIImage {
     func rotated(byDegrees degrees: Int) -> UIImage {
         guard degrees % 360 != 0 else { return self }
  
         let radians = CGFloat(degrees) * .pi / 180
         var newSize = CGRect(origin: .zero, size: size)
             .applying(CGAffineTransform(rotationAngle: radians))
             .size
         newSize.width = floor(newSize.width)
         newSize.height = floor(newSize.height)
  
         UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
         defer { UIGraphicsEndImageContext() }
  
         guard let context = UIGraphicsGetCurrentContext() else { return self }
         context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
         context.rotate(by: radians)
         draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
  
         return UIGraphicsGetImageFromCurrentImageContext() ?? self
     }
 }
