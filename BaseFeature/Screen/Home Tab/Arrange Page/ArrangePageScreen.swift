//
//  ArrangePageScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 17/08/26.
//

import SwiftUI
import Photos

struct ArrangePageScreen: View {
    @StateObject var viewModel: ArrangePageViewModel
    @State private var showAddImagesSheet = false

    /// Called with the final ordered list when the user taps "Next"
    var onNext: (([PHAsset]) -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.selectedAssets.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .padding(.horizontal, 16)
        .safeAreaInset(edge: .bottom) {
            bottomToolbar
        }
        .defaultPage()
        .sheet(isPresented: $showAddImagesSheet) {
            PhotoPickerView { newAssets in
                viewModel.addAssets(newAssets)
            }
        }
    }

    // MARK: - Header: "Next" normally, becomes "Done" while in remove mode
    private var header: some View {
        ZStack {
            HStack {
                HStack {
                    Button {
                        NotificationCenter.default.post(name: .imagesArranged, object: viewModel.selectedAssets)
                        Router.shared.pop()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 32, height: 32, alignment: .center)
                    }
                    Spacer()
                }
                .frame(width: 55)
                
                Spacer()
                
                Text("ARRANGE_PAGE".localized())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteColour)
                
                Spacer()
                
                ZStack {
                    Button(viewModel.isRemoveMode ? "DONE".localized() : "NEXT".localized()) {
                        if viewModel.isRemoveMode {
                            viewModel.isRemoveMode = false
                        } else {
                            onNext?(viewModel.selectedAssets)
                            Router.shared.push(.rotateImage(images: viewModel.selectedAssets))
                        }
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.purple)
                    .padding(.trailing, 16)
                    .disabled(!viewModel.isRemoveMode && viewModel.selectedAssets.isEmpty)
                }
                .frame(width: 55, height: 30, alignment: .center)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.stack")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("NO_PAGE".localized())
                .foregroundColor(.white)
            Text("TAP_ADD_IMG".localized())
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Reorderable / removable list
    private var list: some View {
        // In remove mode, each row shows its own minus icon that deletes on a
        // single tap — no system swipe/confirm step. Reordering (drag handle)
        // still works in both modes.
        return List {
            ForEach(Array(viewModel.selectedAssets.enumerated()), id: \.element.localIdentifier) { index, asset in
                ArrangePageRow(
                    asset: asset,
                    index: index,
                    isRemoveMode: viewModel.isRemoveMode,
                    viewModel: viewModel
                )
                .padding(.vertical, 8)
                .listRowBackground(
                    rowBackground
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 4)
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .onMove(perform: viewModel.move)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, .constant(.active))
        .padding(.top)
        .onChange(of: viewModel.selectedAssets.count) { newCount in
            // All images removed -> go back automatically
            if newCount == 0 {
                Router.shared.pop()
            }
        }
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(Color.white.opacity(0.06))
    }

    private var bottomToolbar: some View {
        HStack(spacing: 34) {
            Spacer()

            Button {
                showAddImagesSheet = true
            } label: {
                VStack(spacing: 4) {
                    VStack {
                        Image("ic_add_more_photo")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.topTobottomGradient)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .padding(10)
                    .background(.grayColour)
                    .cornerRadius(30)
                    
                    Text("ADD_IMAGE".localized())
                        .font(.caption)
                        .foregroundColor(.whiteColour)
                }
                .foregroundColor(.white)
            }
            
            Button {
                viewModel.toggleRemoveMode()
            } label: {
                VStack(spacing: 4) {
                    VStack {
                        Image(systemName: "trash.fill")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.topTobottomGradient)
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                    .padding(10)
                    .background(viewModel.isRemoveMode ? .whiteColour : .grayColour)
                    .cornerRadius(30)
                    
                    Text("REMOVE".localized())
                        .font(.caption)
                        .foregroundColor(.whiteColour)
                }
                .foregroundColor(viewModel.isRemoveMode ? .red : .white)
            }
            .disabled(viewModel.selectedAssets.isEmpty)

            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.black)
    }
}

// MARK: - One row: thumbnail + filename + date/size, with either a number badge or (in remove mode) nothing extra — the system minus control renders itself on the leading edge
struct ArrangePageRow: View {
    let asset: PHAsset
    let index: Int
    let isRemoveMode: Bool
    @ObservedObject var viewModel: ArrangePageViewModel

    @State private var thumbnail: UIImage?
    @State private var filename: String = "IMG_0000.jpg"
    @State private var subtitle: String = ""

    var body: some View {
        HStack(spacing: 12) {
            if isRemoveMode {
                Button {
                    viewModel.remove(asset)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            } else {
                Text("\(index + 1)")
                    .foregroundColor(.whiteColour)
                    .font(.system(size: 18, weight: .regular))
                    .frame(width: 30, height: 30)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(.whiteColour.opacity(0.15))
                    })
            }

            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(filename)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 6)
        .onAppear {
            viewModel.requestThumbnail(for: asset, size: CGSize(width: 96, height: 96)) { image in
                self.thumbnail = image
            }
            viewModel.requestMetadata(for: asset) { name, sub in
                self.filename = name
                self.subtitle = sub
            }
        }
    }
}

#Preview {
    ArrangePageScreen(viewModel: ArrangePageViewModel())
}
