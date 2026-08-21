////
////  StorageManager.swift
////  BaseFeature
////
////  Created by Kushang kaklotar on 11/08/26.
////
//
//import Foundation
//import Combine
//import Photos
//import SwiftUI
//
//class StorageManager: ObservableObject {
//    @Published var freeSpace: String = ""
//    @Published var totalSpace: String = ""
//    @Published var usedSpace: String = ""
//    @Published var storageInfo: [StrogeInfo] = []
//    @Published var photoStatus: PHAuthorizationStatus = .denied
//    @Published var usedStoragePercent: Double = 0.0
//    
//    var usedSize: Int = 0
//    
//    init() {
//        self.fetchStorageInfo()
//        self.scanPhotoLibrary()
//    }
//    
//    func fetchStorageInfo() {
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
//        
//        do {
//            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: documentDirectory)
//            
//            if let freeSize = systemAttributes[.systemFreeSize] as? Int64,
//               let totalSize = systemAttributes[.systemSize] as? Int64 {
//                
//                self.usedSize = Int(totalSize - freeSize)
//                
//                let formatter = ByteCountFormatter()
//                formatter.allowedUnits = [.useGB, .useMB]
//                formatter.countStyle = .file
//                
//                self.freeSpace = formatter.string(fromByteCount: freeSize)
//                self.totalSpace = formatter.string(fromByteCount: totalSize)
//                self.usedSpace = formatter.string(fromByteCount: Int64(self.usedSize))
//                
//                // Percent calculate karo
//                if totalSize > 0 {
//                    self.usedStoragePercent = Double(usedSize) / Double(totalSize)
//                }
//            }
//        } catch {
//            print("Error retrieving storage info: \(error.localizedDescription)")
//        }
//    }
//    
//    func scanPhotoLibrary() {
//         PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
//             switch status {
//             case .notDetermined:
//                 self?.photoStatus = .notDetermined
//             case .restricted:
//                 self?.photoStatus = .restricted
//             case .denied:
//                 self?.photoStatus = .denied
//             case .authorized:
//                 DispatchQueue.main.async {
//                     self?.photoStatus = .authorized
//                     self?.calculateSizes()
//                 }
//             case .limited:
//                 DispatchQueue.main.async {
//                     self?.photoStatus = .limited
//                     self?.calculateSizes()
//                 }
//             @unknown default:
//                 self?.photoStatus = .denied
//             }
//         }
//     }
//
//     func calculateSizes() {
//         DispatchQueue.global(qos: .userInitiated).async {
//             let fetchOptions = PHFetchOptions()
//             let allAssets = PHAsset.fetchAssets(with: fetchOptions)
//             
//             var totalPhotosBytes: Int64 = 0
//             var totalVideosBytes: Int64 = 0
//             
//             allAssets.enumerateObjects { (asset, _, _) in
//                 // Fetch resource metadata without downloading the full asset file
//                 let resources = PHAssetResource.assetResources(for: asset)
//                 if let resource = resources.first,
//                    let sizeOnDisk = resource.value(forKey: "fileSize") as? Int64 {
//                     
//                     if asset.mediaType == .image {
//                         totalPhotosBytes += sizeOnDisk
//                     } else if asset.mediaType == .video {
//                         totalVideosBytes += sizeOnDisk
//                     }
//                 }
//             }
//             
//             DispatchQueue.main.async {
//                 let formatter = ByteCountFormatter()
//                 formatter.allowedUnits = [.useGB, .useMB]
//                 formatter.countStyle = .file
//                 
//                 let photosSize = formatter.string(fromByteCount: totalPhotosBytes)
//                 let videosSize = formatter.string(fromByteCount: totalVideosBytes)
//                 
//                 let other = (self.usedSize - Int(totalPhotosBytes)) - Int(totalVideosBytes)
//                 let otherSize = formatter.string(fromByteCount: Int64(other))
//                 
//                 if totalPhotosBytes > 0 {
//                     let precent = Double(totalPhotosBytes) / Double(self.usedSize) * 100
//                     self.storageInfo.append(StrogeInfo(id: 0, name: "PHOTO", image: "ic_photo", storage: photosSize, percent: precent,
//                                                        gradient: LinearGradient(colors: [.lightPurple, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 } else {
//                     self.storageInfo.append(StrogeInfo(id: 0, name: "PHOTO", image: "ic_photo", storage: "0 KB", percent: 0,
//                                                        gradient: LinearGradient(colors: [.lightPurple, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 }
//                 
//                 if totalVideosBytes > 0 {
//                     let precent = Double(totalVideosBytes) / Double(self.usedSize) * 100
//                     self.storageInfo.append(StrogeInfo(id: 1, name: "VIDEO", image: "ic_video", storage: videosSize, percent: precent,
//                                                        gradient: LinearGradient(colors: [.lightBabyPinkColour, .darkBabyPinkColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 } else {
//                     self.storageInfo.append(StrogeInfo(id: 1, name: "VIDEO", image: "ic_video", storage: "0 KB", percent: 0,
//                                                        gradient: LinearGradient(colors: [.lightBabyPinkColour, .darkBabyPinkColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 }
//                 
//                 if other > 0 {
//                     let precent = Double(other) / Double(self.usedSize) * 100
//                     self.storageInfo.append(StrogeInfo(id: 2, name: "OTHER", image: "ic_documents", storage: otherSize, percent: precent,
//                                                        gradient: LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 } else {
//                     self.storageInfo.append(StrogeInfo(id: 2, name: "OTHER", image: "ic_documents", storage: "0 KB", percent: 0,
//                                                        gradient: LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .topLeading, endPoint: .bottomTrailing)))
//                 }
//             }
//         }
//     }
//
//}
import Foundation
import Photos
import SwiftUI
import Combine

class StorageManager: ObservableObject {
    
    static let shared = StorageManager()          // ← Singleton (App ma ek j instance)
    
    @Published var freeSpace: String = "—"
    @Published var totalSpace: String = "—"
    @Published var usedSpace: String = "—"
    @Published var usedStoragePercent: Double = 0.0
    @Published var storageInfo: [StrogeInfo] = []
    @Published var photoStatus: PHAuthorizationStatus = .notDetermined
    @Published var isLoading: Bool = false
    
    private var usedSize: Int64 = 0
    private var hasCalculated = false
    private var cancellables = Set<AnyCancellable>()
    
    // Cache freshness window (in seconds). Adjust to taste.
    private let cacheFreshnessInterval: TimeInterval = 3600 // 1 hour
    
    private init() {
        fetchDeviceStorage()
        requestPhotoPermissionAndScan()
    }
    
    // MARK: - Device Storage (Fast)
    private func fetchDeviceStorage() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: path)
            
            if let free = attributes[.systemFreeSize] as? Int64,
               let total = attributes[.systemSize] as? Int64 {
                
                usedSize = total - free
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useGB, .useMB]
                formatter.countStyle = .file
                
                freeSpace = formatter.string(fromByteCount: free)
                totalSpace = formatter.string(fromByteCount: total)
                usedSpace = formatter.string(fromByteCount: usedSize)
                
                usedStoragePercent = total > 0 ? Double(usedSize) / Double(total) : 0
            }
        } catch {
            print("Storage error:", error.localizedDescription)
        }
    }
    
    // MARK: - Photo Permission + Scan (Only Once, unless cache is stale)
    private func requestPhotoPermissionAndScan() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            photoStatus = status
            startScanRespectingCache()
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                DispatchQueue.main.async {
                    self?.photoStatus = newStatus
                    if newStatus == .authorized || newStatus == .limited {
                        self?.startScanRespectingCache()
                    }
                }
            }
            
        default:
            photoStatus = status
        }
    }
    
    /// Loads a fresh cached result if available; otherwise kicks off a real scan.
    private func startScanRespectingCache() {
        if loadCachedResultIfFresh() {
            hasCalculated = true // skip rescanning this session; forceRefresh() still works
        } else {
            calculatePhotoVideoSizes()
        }
    }
    
    // MARK: - Calculate Photos + Videos (Only Once per session)
    private func calculatePhotoVideoSizes() {
        guard !hasCalculated else { return }      // ← Bahu important
        hasCalculated = true
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let allAssets = PHAsset.fetchAssets(with: nil)
            
            // Thread-safe accumulators since .concurrent enumeration
            // can call the block from multiple threads simultaneously.
            let lock = NSLock()
            var photosBytes: Int64 = 0
            var videosBytes: Int64 = 0
            
            // .concurrent lets Photos process multiple assets in parallel
            // across CPU cores instead of one-by-one, which is the biggest
            // speed win on large libraries (common on iPad).
            allAssets.enumerateObjects(options: [.concurrent]) { asset, _, _ in
                // autoreleasepool drains temporary PHAssetResource objects
                // every iteration instead of letting them pile up until the
                // whole loop finishes — keeps memory (and speed) stable on
                // libraries with tens of thousands of items.
                autoreleasepool {
                    let resources = PHAssetResource.assetResources(for: asset)
                    guard let resource = resources.first,
                          let size = resource.value(forKey: "fileSize") as? Int64 else { return }
                    
                    lock.lock()
                    if asset.mediaType == .image {
                        photosBytes += size
                    } else if asset.mediaType == .video {
                        videosBytes += size
                    }
                    lock.unlock()
                }
            }
            
            let otherBytes = max(self.usedSize - photosBytes - videosBytes, 0)
            
            DispatchQueue.main.async {
                self.updateUI(photos: photosBytes, videos: videosBytes, other: otherBytes)
                self.isLoading = false
                self.cacheResult(photos: photosBytes, videos: videosBytes, other: otherBytes)
            }
        }
    }
    
    // MARK: - Update UI
    private func updateUI(photos: Int64, videos: Int64, other: Int64) {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        
        storageInfo.removeAll()
        
        // Photos
        let photoPercent = usedSize > 0 ? Double(photos) / Double(usedSize) * 100 : 0
        storageInfo.append(StrogeInfo(
            id: 0,
            name: "PHOTO",
            image: "ic_photo",
            storage: formatter.string(fromByteCount: photos),
            percent: photoPercent,
            gradient: LinearGradient(colors: [.lightPurple, .purpleColour], startPoint: .topLeading, endPoint: .bottomTrailing)
        ))
        
        // Videos
        let videoPercent = usedSize > 0 ? Double(videos) / Double(usedSize) * 100 : 0
        storageInfo.append(StrogeInfo(
            id: 1,
            name: "VIDEO",
            image: "ic_video",
            storage: formatter.string(fromByteCount: videos),
            percent: videoPercent,
            gradient: LinearGradient(colors: [.lightBabyPinkColour, .darkBabyPinkColour], startPoint: .topLeading, endPoint: .bottomTrailing)
        ))
        
        // Other
        let otherPercent = usedSize > 0 ? Double(other) / Double(usedSize) * 100 : 0
        storageInfo.append(StrogeInfo(
            id: 2,
            name: "OTHER",
            image: "ic_documents",
            storage: formatter.string(fromByteCount: other),
            percent: otherPercent,
            gradient: LinearGradient(colors: [.lightYellowColour, .orangeColour], startPoint: .topLeading, endPoint: .bottomTrailing)
        ))
    }
    
    // MARK: - Cache (avoids rescanning the whole library every launch)
    private func cacheResult(photos: Int64, videos: Int64, other: Int64) {
        UserDefaults.standard.set(photos, forKey: "cachedPhotosBytes")
        UserDefaults.standard.set(videos, forKey: "cachedVideosBytes")
        UserDefaults.standard.set(other, forKey: "cachedOtherBytes")
        UserDefaults.standard.set(Date(), forKey: "cachedStorageDate")
    }
    
    /// Returns true and updates the UI if a fresh cached result was found.
    private func loadCachedResultIfFresh() -> Bool {
        guard let date = UserDefaults.standard.object(forKey: "cachedStorageDate") as? Date,
              Date().timeIntervalSince(date) < cacheFreshnessInterval else {
            return false
        }
        
        // Guard against the "never cached before" case where these would
        // all default to 0 and still pass the date check incorrectly.
        guard UserDefaults.standard.object(forKey: "cachedPhotosBytes") != nil else {
            return false
        }
        
        let photos = Int64(UserDefaults.standard.integer(forKey: "cachedPhotosBytes"))
        let videos = Int64(UserDefaults.standard.integer(forKey: "cachedVideosBytes"))
        let other = Int64(UserDefaults.standard.integer(forKey: "cachedOtherBytes"))
        
        updateUI(photos: photos, videos: videos, other: other)
        return true
    }
    
    // MARK: - Force Refresh (Optional - Settings ma button mate)
    func forceRefresh() {
        hasCalculated = false
        storageInfo.removeAll()
        UserDefaults.standard.removeObject(forKey: "cachedStorageDate") // invalidate cache
        fetchDeviceStorage()
        calculatePhotoVideoSizes()
    }
}
