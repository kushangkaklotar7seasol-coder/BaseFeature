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
    @Published var pdfToRename: URL?
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

//    func renamePDF(at url: URL, to newName: String) {
//        var finalName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
//     
//        // Ensure the .pdf extension is present (case-insensitive check)
//        if finalName.lowercased().hasSuffix(".pdf") == false {
//            finalName += ".pdf"
//        }
//     
//        let destinationURL = url.deletingLastPathComponent().appendingPathComponent(finalName)
//     
//        do {
//            // If a file with the target name already exists, remove it first (overwrite)
//            if FileManager.default.fileExists(atPath: destinationURL.path) {
//                try FileManager.default.removeItem(at: destinationURL)
//            }
//            try FileManager.default.moveItem(at: url, to: destinationURL)
//            self.pdfs = self.fetchSavedPDFs()
////            return destinationURL
//        } catch {
//            print("Failed to rename PDF: \(error)")
////            return nil
//        }
//    }
    
    func renamePDF(at url: URL, to newName: String, completion: @escaping () -> Void, failure: @escaping (String) -> Void) {
        var finalName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
     
        guard !finalName.isEmpty else {
            failure("NAME_NOT_EMPTY".localized())
            return
        }
     
        if finalName.lowercased().hasSuffix(".pdf") == false {
            finalName += ".pdf"
        }
     
        let destinationURL = url.deletingLastPathComponent().appendingPathComponent(finalName)
     
        // Renaming to the exact same name — nothing to do, not an error
        if destinationURL.path == url.path {
            completion()
            return
        }
     
        // Name already taken by another file — do NOT rename/overwrite, report failure instead
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            failure("PDF_WITN_NAME_EXIST".localized())
            return
        }
     
        do {
            try FileManager.default.moveItem(at: url, to: destinationURL)
            completion()
        } catch {
            failure("NOT_ABLE_SAVE".localized())
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
    var isShowHeader: Bool = true
    var lastPDFDeleted: (()->Void)?
    @State private var showAlert = false
    @State private var userInput = ""
    
    var body: some View {
        VStack {
            if !viewModel.pdfs.isEmpty {
                if isShowHeader {
                    DefaultDesign.SectionHeader(name: "RECENT_FILE", onClick: {
                        Router.shared.push(.recentpdf(simpleBack: true))
                    })
                    .padding(.top, 10)
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.pdfs, id: \.self) { url in
                        Button {
                            viewModel.generatedPDFURL = url
                            viewModel.showPreview = true
                        } label: {
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
//                                .onTapGesture {
//                                    viewModel.generatedPDFURL = url
//                                    viewModel.showPreview = true
//                                }
                                
                                Spacer()
                                
                                Menu {
                                    Button {
                                        viewModel.pdfToRename = url
                                        self.userInput = url.lastPathComponent
                                        self.showAlert = true
                                    } label: {
                                        Label("RENAME".localized(), systemImage: "pencil.tip.crop.circle")
                                    }
                                    
                                    Button {
                                        viewModel.pdfToShare = url
                                        viewModel.showShareSheet = true
                                    } label: {
                                        Label("SHARE".localized(), systemImage: "square.and.arrow.up")
                                    }
                                    
                                    Button(role: .destructive) {
                                        AlertManager.shared.show(
                                            title: "DELETE_PDF".localized(),
                                            message: "DELETE_PDF_INFO".localized(),
                                            buttons: [
                                                AlertButtonModel(title: "CANCEL".localized(), role: .cancel),
                                                AlertButtonModel(title: "DELETE".localized(), role: .destructive) {
                                                    viewModel.deletePDF(at: url)
                                                    if viewModel.pdfs.count <= 0 {
                                                        self.lastPDFDeleted?()
                                                    }
                                                }
                                            ]
                                        )
                                    } label: {
                                        Label("DELETE".localized(), systemImage: "trash")
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
        .alert("RENAME_PDF".localized(), isPresented: $showAlert) {
            TextField("ASSIGNMENT.PDF", text: $userInput)
                .textInputAutocapitalization(.words)
            
            Button("RENAME".localized()) {
                if self.userInput != "" {
                    viewModel.renamePDF(at: viewModel.pdfToRename ?? URL(filePath: ""), to: userInput, completion: {
                        viewModel.pdfs = viewModel.fetchSavedPDFs()
                    }, failure: { error in
                        Toast.shared.show(message: error, type: .error)
                    })
                }
            }
            .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            
            Button("CANCEL".localized(), role: .cancel) { }
        }
    }
}
