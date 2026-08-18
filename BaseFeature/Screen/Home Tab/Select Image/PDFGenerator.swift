import UIKit
import Photos


struct PDFSummary {
    let totalPages: Int
    let sizeInMB: Double
    let sizeFormatted: String   // e.g. "5.7 MB"
}
 

enum PDFGenerator {
    /// Generates one PDF containing all given images in order (one image per page, in sequence)
    static func generatePDF(from images: [UIImage], fileName: String = "Photos") -> URL? {
        guard !images.isEmpty else { return nil }

        let pdfMetaData = [
            kCGPDFContextCreator: "Image to PDF",
            kCGPDFContextTitle: fileName
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth: CGFloat = 612   // US Letter, points
        let pageHeight: CGFloat = 792
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("\(fileName)-\(UUID().uuidString).pdf")

        do {
            try renderer.writePDF(to: fileURL) { context in
                for image in images {
                    context.beginPage()

                    let margin: CGFloat = 20
                    let maxWidth = pageWidth - (margin * 2)
                    let maxHeight = pageHeight - (margin * 2)

                    let aspectRatio = image.size.width / image.size.height
                    var drawWidth = maxWidth
                    var drawHeight = drawWidth / aspectRatio

                    if drawHeight > maxHeight {
                        drawHeight = maxHeight
                        drawWidth = drawHeight * aspectRatio
                    }

                    let x = (pageWidth - drawWidth) / 2
                    let y = (pageHeight - drawHeight) / 2

                    image.draw(in: CGRect(x: x, y: y, width: drawWidth, height: drawHeight))
                }
            }
            return fileURL
        } catch {
            print("PDF generation failed: \(error)")
            return nil
        }
    }
    
   /// Call this from any screen with the generated PDF's URL and the selected assets array.
    static func getPDFSummary(pdfURL: URL) -> PDFSummary? {
       guard let document = CGPDFDocument(pdfURL as CFURL) else { return nil }
       let totalPages = document.numberOfPages
    
       let attributes = try? FileManager.default.attributesOfItem(atPath: pdfURL.path)
       let sizeBytes = (attributes?[.size] as? Int64) ?? 0
       let sizeInMB = Double(sizeBytes) / (1024 * 1024)
       let sizeFormatted = ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
    
       return PDFSummary(
           totalPages: totalPages,
           sizeInMB: sizeInMB,
           sizeFormatted: sizeFormatted
       )
   }
}

 
