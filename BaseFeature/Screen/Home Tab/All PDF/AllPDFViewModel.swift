//
//  AllPDFViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 19/08/26.
//

import Foundation
import Combine
import SwiftUI

class AllPDFViewModel: ObservableObject {
    @Published var pdfToShare: URL?
    @Published var showShareSheet = false
    @Published var pdfs: [URL] = []
    @Published var showPreview = false
    @Published var generatedPDFURL: URL?
    
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

            // Newest first
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

    func pdfSubtitle(for url: URL) -> String {
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)

        let sizeBytes = (attributes?[.size] as? Int64) ?? 0
        let sizeText = ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let dateText: String
        if let creationDate = attributes?[.creationDate] as? Date {
            dateText = dateFormatter.string(from: creationDate)
        } else {
            dateText = "--"
        }

        return "\(dateText) • \(sizeText)"
    }

    func deletePDF(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            pdfs.removeAll { $0 == url }
        } catch {
            print("Failed to delete PDF: \(error)")
        }
    }
}

struct AllPDFView: View {
    @StateObject var viewModel = AllPDFViewModel()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.pdfs, id: \.self) { url in
                    HStack {
                        HStack {
                            Image("ic_pdf_red")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)

                            VStack(alignment: .leading, spacing: 5) {
                                Text(url.lastPathComponent)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.whiteColour)
                                    .lineLimit(1)

                                Text(viewModel.pdfSubtitle(for: url))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.grayColour)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.generatedPDFURL = url
                            viewModel.showPreview = true
                        }

                        Spacer()

                        Menu {
                            Button {
                                viewModel.pdfToShare = url
                                viewModel.showShareSheet = true
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }

                            Button(role: .destructive) {
                                viewModel.deletePDF(at: url)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image("ic_more")
                                .resizable()
                                .frame(width: 25, height: 25, alignment: .center)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding()
                    .background(.whiteColour.opacity(0.08))
                    .cornerRadius(12)
                }
            }
        }
        .onAppear() {
            viewModel.pdfs = viewModel.fetchSavedPDFs()
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let url = viewModel.pdfToShare {
                ShareSheet(activityItems: [url])
            }
         }
        .fullScreenCover(isPresented: $viewModel.showPreview, content: {
            if let url = viewModel.generatedPDFURL {
                PDFPreviewScreen(url: url)
            }
        })
    }
}
