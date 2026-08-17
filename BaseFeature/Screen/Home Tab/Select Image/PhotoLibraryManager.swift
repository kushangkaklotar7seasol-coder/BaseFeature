import SwiftUI
import Combine
import Photos

@MainActor
final class PhotoLibraryManager: ObservableObject {

    // MARK: - Access state (this is the "variable" that tracks permission result)
    enum AccessState {
        case notDetermined
        case limited        // user gave access to only some photos
        case authorized      // full access
        case denied
        case restricted
    }

    @Published var accessState: AccessState = .notDetermined
    @Published var groupedAssets: [PhotoGroup] = []
    @Published var isLoading: Bool = false
    @Published var selectedAssets: [PHAsset] = []

    struct PhotoGroup: Identifiable {
        let id = UUID()
        let date: Date
        var assets: [PHAsset]
    }

    private let imageManager = PHCachingImageManager()

    // MARK: - Step 1: Check access first
    func checkAuthorization() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        updateAccessState(from: status)

        switch status {
        case .notDetermined:
            requestAuthorization()
        case .authorized, .limited:
            // limited access -> we still fetch & display whatever photos were granted
            fetchAllPhotos()
        default:
            break
        }
    }

    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                self?.updateAccessState(from: status)
                if status == .authorized || status == .limited {
                    self?.fetchAllPhotos()
                }
            }
        }
    }

    private func updateAccessState(from status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: accessState = .notDetermined
        case .restricted: accessState = .restricted
        case .denied: accessState = .denied
        case .authorized: accessState = .authorized
        case .limited: accessState = .limited
        @unknown default: accessState = .denied
        }
    }

    // MARK: - Step 2: Fetch ALL photos from Photos app
    func fetchAllPhotos() {
        isLoading = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }

            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let result = PHAsset.fetchAssets(with: .image, options: options)

            var groups: [Date: [PHAsset]] = [:]
            let calendar = Calendar.current

            result.enumerateObjects { asset, _, _ in
                let date = asset.creationDate ?? Date()
                let dayStart = calendar.startOfDay(for: date)
                groups[dayStart, default: []].append(asset)
            }

            let sortedGroups = groups
                .sorted { $0.key > $1.key }
                .map { PhotoGroup(date: $0.key, assets: $0.value) }

            DispatchQueue.main.async {
                self.groupedAssets = sortedGroups
                self.isLoading = false
            }
        }
    }

    // MARK: - Selection handling
    func toggleSelection(_ asset: PHAsset) {
        if let index = selectedAssets.firstIndex(of: asset) {
            selectedAssets.remove(at: index)
        } else {
            selectedAssets.append(asset)
        }
    }

    func isSelected(_ asset: PHAsset) -> Bool {
        selectedAssets.contains(asset)
    }

    func selectAll() {
        let all = groupedAssets.flatMap { $0.assets }
        if selectedAssets.count == all.count && !all.isEmpty {
            selectedAssets.removeAll()
        } else {
            selectedAssets = all
        }
    }

    // Select/deselect all photos belonging to a single date group only
    func isAllSelected(in group: PhotoGroup) -> Bool {
        !group.assets.isEmpty && group.assets.allSatisfy { selectedAssets.contains($0) }
    }

    func toggleSelectAll(for group: PhotoGroup) {
        if isAllSelected(in: group) {
            selectedAssets.removeAll { group.assets.contains($0) }
        } else {
            for asset in group.assets where !selectedAssets.contains(asset) {
                selectedAssets.append(asset)
            }
        }
    }

    func removeFromSelection(_ asset: PHAsset) {
        selectedAssets.removeAll { $0 == asset }
    }

    // MARK: - Image loading
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
}
