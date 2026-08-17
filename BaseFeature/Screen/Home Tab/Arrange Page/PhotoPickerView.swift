import SwiftUI
import PhotosUI
import Photos

/// Wraps the native photo picker so it can be shown as a SwiftUI .sheet.
/// Selecting photos here calls back with the picked PHAssets, in the order they were tapped.
struct PhotoPickerView: UIViewControllerRepresentable {
    var onSelect: ([PHAsset]) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0 // 0 = unlimited

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect)
    }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onSelect: ([PHAsset]) -> Void

        init(onSelect: @escaping ([PHAsset]) -> Void) {
            self.onSelect = onSelect
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // assetIdentifier is populated because we already have photo library access
            let identifiers = results.compactMap { $0.assetIdentifier }

            guard !identifiers.isEmpty else {
                picker.dismiss(animated: true)
                return
            }

            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
            var assets: [PHAsset] = []
            fetchResult.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }

            onSelect(assets)
            picker.dismiss(animated: true)
        }
    }
}
