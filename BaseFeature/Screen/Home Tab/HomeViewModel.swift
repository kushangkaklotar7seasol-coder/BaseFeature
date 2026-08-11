//
//  HomeViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 11/08/26.
//

import Foundation
import Combine
import Photos
import MediaPlayer

class HomeViewModel: ObservableObject {
    @Published var freeSpace: String = "Calculating..."
    @Published var totalSpace: String = "Calculating..."
    @Published var usedSpace: String = "Calculating..."
    
    @Published var storageInfo: [StrogeInfo] = []
    
    func fetchStorageInfo() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        do {
            let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: documentDirectory)
            
            if let freeSize = systemAttributes[.systemFreeSize] as? Int64,
               let totalSize = systemAttributes[.systemSize] as? Int64 {
                
                let usedSize = totalSize - freeSize
                
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useGB, .useMB]
                formatter.countStyle = .file
                
                self.freeSpace = formatter.string(fromByteCount: freeSize)
                self.totalSpace = formatter.string(fromByteCount: totalSize)
                self.usedSpace = formatter.string(fromByteCount: usedSize)
            }
        } catch {
            print("Error retrieving storage info: \(error.localizedDescription)")
        }
    }
    
    func scanPhotoLibrary() {
         PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
             guard status == .authorized || status == .limited else {
                 self?.scanSandboxFiles()
                 return
             }
             
             self?.calculateSizes()
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
                 
                 self.storageInfo.append(StrogeInfo(id: 0, name: "Photo", storage: photosSize, percent: 0))
                 self.storageInfo.append(StrogeInfo(id: 1, name: "Video", storage: videosSize, percent: 0))
                 self.scanSandboxFiles()
             }
         }
     }
    
    
    func scanSandboxFiles() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        print("📁 Scanning path: \(documentsURL.path)")   // <-- add karo
        
        var audioBytes: Int64 = 0
        var docBytes: Int64 = 0
        var fileCount = 0   // <-- add karo
        
        let audioExtensions = ["mp3", "m4a", "wav", "caf"]   // gif hatavi didhu, e image che
        let documentExtensions = ["pdf", "txt", "docx", "json", "csv", "xls", "html", "pptx", "txt", "docx"]
        
        if let enumerator = fileManager.enumerator(at: documentsURL, includingPropertiesForKeys: [.fileSizeKey]) {
            for case let fileURL as URL in enumerator {
                fileCount += 1
                print("Found file: \(fileURL.lastPathComponent)")   // <-- add karo
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                    if let fileSize = resourceValues.fileSize {
                        let ext = fileURL.pathExtension.lowercased()
                        if audioExtensions.contains(ext) {
                            audioBytes += Int64(fileSize)
                        } else if documentExtensions.contains(ext) {
                            docBytes += Int64(fileSize)
                        }
                    }
                } catch {
                    print("Error checking local file: \(error)")
                }
            }
        }
        
        print("Total files found in sandbox: \(fileCount)")   // <-- add karo
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB, .useKB]
        formatter.countStyle = .file
        
        let audioSize = formatter.string(fromByteCount: audioBytes)
        let documentsSize = formatter.string(fromByteCount: docBytes)
        
        // ... baki formatter code same
//        self.storageInfo.append(StrogeInfo(id: 2, name: "Audio", storage: audioSize, percent: 0))
//        self.storageInfo.append(StrogeInfo(id: 3, name: "Document", storage: documentsSize, percent: 0))
        
        self.getAudioStorageSize()
    }
    
    func getAudioStorageSize() {
        MPMediaLibrary.requestAuthorization { status in
            guard status == .authorized else {
                print("❌ Media Access Denied")
                return
            }
            
            let query = MPMediaQuery.songs()
            var totalAudioBytes: Int64 = 0
            var songCount = 0
            
            if let items = query.items {
                for item in items {
                    // ૧. માત્ર ફોનમાં ડાઉનલોડ થયેલા લોકલ ઓડિયો જ મળશે
                    guard let assetURL = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else {
                        continue // Cloud / DRM Protected ગીતો માટે ડાયરેક્ટ URL નથી મળતું
                    }
                    
                    songCount += 1
                    
                    // ૨. AVURLAsset થી ગીતની લંબાઈ (Duration) મેળવવી
                    let asset = AVURLAsset(url: assetURL)
                    let durationInSeconds = CMTimeGetSeconds(asset.duration)
                    
                    if !durationInSeconds.isNaN && durationInSeconds > 0 {
                        // Standard AAC Audio ની એવરેજ બિટરેટ ૨૫૬ kbps હોય છે (32,000 Bytes per second)
                        let bytesPerSecond: Double = (256 * 1000) / 8
                        let estimatedFileSize = Int64(durationInSeconds * bytesPerSecond)
                        
                        totalAudioBytes += estimatedFileSize
                    }
                }
            }
            
            DispatchQueue.main.async {
                let formatter = ByteCountFormatter()
                formatter.countStyle = .file
                let formattedSize = formatter.string(fromByteCount: totalAudioBytes)
                
                print("🎵 Total Songs Found: \(songCount)")
                print("📊 Total Audio Storage: \(formattedSize)")
                self.storageInfo.append(StrogeInfo(id: 2, name: "Audio", storage: formattedSize, percent: 0))
            }
        }
    }
}
