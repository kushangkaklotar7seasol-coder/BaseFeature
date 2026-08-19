import SwiftUI
import UniformTypeIdentifiers

// MARK: - 1. Save permanently inside the app's own storage
// The PDF from PDFGenerator lives in a TEMPORARY folder and can get deleted by
// iOS at any time. Call this to copy it somewhere permanent so it's still
// there next time the app launches.
func savePDFToDocuments(from tempURL: URL, fileName: String = "Document.pdf") -> URL? {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let destinationURL = documentsURL.appendingPathComponent(fileName)

    do {
        // Overwrite if a file with the same name already exists
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.copyItem(at: tempURL, to: destinationURL)
        return destinationURL
    } catch {
        print("Failed to save PDF: \(error)")
        return nil
    }
}

// Usage from any screen:
// if let savedURL = savePDFToDocuments(from: generatedPDFURL, fileName: "MyDocument.pdf") {
//     print("Saved at:", savedURL)
// }


// MARK: - Fetch all PDFs previously saved to Documents (newest first)
func fetchSavedPDFs() -> [URL] {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return []
    }

    do {
        let files = try FileManager.default.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: [.creationDateKey],
            options: .skipsHiddenFiles
        )

        let pdfFiles = files.filter { $0.pathExtension.lowercased() == "pdf" }

        return pdfFiles.sorted { lhs, rhs in
            let lhsDate = (try? lhs.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? .distantPast
            let rhsDate = (try? rhs.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? .distantPast
            return lhsDate > rhsDate
        }
    } catch {
        print("Failed to list saved PDFs: \(error)")
        return []
    }
}

// Usage from any screen:
// let allPDFs = fetchSavedPDFs()
// for url in allPDFs { print(url.lastPathComponent) }


// MARK: - 2. Let the user save to the Files app (their choice of folder / iCloud Drive)
// This is what "Save PDF to Files" normally means on iOS, since Photos doesn't accept PDFs.
struct SaveToFilesPicker: UIViewControllerRepresentable {
    let url: URL
    var onSaved: (() -> Void)? = nil

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: [url])
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onSaved: onSaved)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onSaved: (() -> Void)?

        init(onSaved: (() -> Void)?) {
            self.onSaved = onSaved
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onSaved?()
        }
    }
}

// Usage from any screen:
// @State private var showSaveToFiles = false
//
// .sheet(isPresented: $showSaveToFiles) {
//     SaveToFilesPicker(url: generatedPDFURL) {
//         print("Saved to Files")
//     }
// }
