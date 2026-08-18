import SwiftUI
import QuickLook

/// Shows a PDF (or any file) inside your own app using Apple's native QuickLook preview —
/// no other app needed, no "Open With" required.
struct PDFPreviewScreen: UIViewControllerRepresentable {
    let url: URL
    @Environment(\.dismiss) private var dismiss
 
    func makeUIViewController(context: Context) -> UINavigationController {
        let previewController = QLPreviewController()
        previewController.dataSource = context.coordinator
 
        previewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: context.coordinator,
            action: #selector(Coordinator.cancelTapped)
        )
 
        return UINavigationController(rootViewController: previewController)
    }
 
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
 
    func makeCoordinator() -> Coordinator {
        Coordinator(url: url, dismiss: dismiss)
    }
 
    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL
        let dismiss: DismissAction
 
        init(url: URL, dismiss: DismissAction) {
            self.url = url
            self.dismiss = dismiss
        }
 
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
 
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            url as QLPreviewItem
        }
 
        @objc func cancelTapped() {
            dismiss()
        }
    }
}
