//
//  StorageManager.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import Foundation
import Combine
import Photos

class StorageManager: ObservableObject {
    @Published var freeSpace: String = ""
    @Published var totalSpace: String = ""
    @Published var usedSpace: String = ""
    @Published var storageInfo: [StrogeInfo] = []
    @Published var photoStatus: PHAuthorizationStatus = .denied
    @Published var usedStoragePercent: Double = 0.0
    
    var usedSize: Int = 0
    
    init() {
        self.fetchStorageInfo()
        self.scanPhotoLibrary()
    }
    
    func fetchStorageInfo() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: documentDirectory)
            
            if let freeSize = systemAttributes[.systemFreeSize] as? Int64,
               let totalSize = systemAttributes[.systemSize] as? Int64 {
                
                self.usedSize = Int(totalSize - freeSize)
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useGB, .useMB]
                formatter.countStyle = .file
                
                self.freeSpace = formatter.string(fromByteCount: freeSize)
                self.totalSpace = formatter.string(fromByteCount: totalSize)
                self.usedSpace = formatter.string(fromByteCount: Int64(self.usedSize))
                
                // Percent calculate karo
                if totalSize > 0 {
                    self.usedStoragePercent = Double(usedSize) / Double(totalSize)
                }
            }
        } catch {
            print("Error retrieving storage info: \(error.localizedDescription)")
        }
    }
    
    func scanPhotoLibrary() {
         PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
             switch status {
             case .notDetermined:
                 self?.photoStatus = .notDetermined
             case .restricted:
                 self?.photoStatus = .restricted
             case .denied:
                 self?.photoStatus = .denied
             case .authorized:
                 DispatchQueue.main.async {
                     self?.photoStatus = .authorized
                     self?.calculateSizes()
                 }
             case .limited:
                 DispatchQueue.main.async {
                     self?.photoStatus = .limited
                     self?.calculateSizes()
                 }
             @unknown default:
                 self?.photoStatus = .denied
             }
         }
     }

     func calculateSizes() {
         DispatchQueue.global(qos: .userInitiated).async {
             let fetchOptions = PHFetchOptions()
             let allAssets = PHAsset.fetchAssets(with: fetchOptions)
             
             var totalPhotosBytes: Int64 = 0
             var totalVideosBytes: Int64 = 0
             
             allAssets.enumerateObjects { (asset, _, _) in
                 // Fetch resource metadata without downloading the full asset file
                 let resources = PHAssetResource.assetResources(for: asset)
                 if let resource = resources.first,
                    let sizeOnDisk = resource.value(forKey: "fileSize") as? Int64 {
                     
                     if asset.mediaType == .image {
                         totalPhotosBytes += sizeOnDisk
                     } else if asset.mediaType == .video {
                         totalVideosBytes += sizeOnDisk
                     }
                 }
             }
             
             DispatchQueue.main.async {
                 let formatter = ByteCountFormatter()
                 formatter.allowedUnits = [.useGB, .useMB]
                 formatter.countStyle = .file
                 
                 let photosSize = formatter.string(fromByteCount: totalPhotosBytes)
                 let videosSize = formatter.string(fromByteCount: totalVideosBytes)
                 
                 let other = (self.usedSize - Int(totalPhotosBytes)) - Int(totalVideosBytes)
                 let otherSize = formatter.string(fromByteCount: Int64(other))
                 
                 if totalPhotosBytes > 0 {
                     let precent = Double(totalPhotosBytes) / Double(self.usedSize) * 100
                     self.storageInfo.append(StrogeInfo(id: 0, name: "Photo", image: "ic_photo", storage: photosSize, percent: precent))
                 }
                 
                 if totalVideosBytes > 0 {
                     let precent = Double(totalVideosBytes) / Double(self.usedSize) * 100
                     self.storageInfo.append(StrogeInfo(id: 1, name: "Video", image: "ic_video", storage: videosSize, percent: precent))
                 }
                 
                 if other > 0 {
                     let precent = Double(other) / Double(self.usedSize) * 100
                     self.storageInfo.append(StrogeInfo(id: 2, name: "Other", image: "ic_documents", storage: otherSize, percent: precent))
                 }
             }
         }
     }

}
