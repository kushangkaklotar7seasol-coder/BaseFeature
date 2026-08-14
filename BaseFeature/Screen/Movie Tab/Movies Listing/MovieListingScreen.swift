//
//  MovieListingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI

struct MovieListingScreen: View {
    @StateObject var viewModel: MovieListingViewModel
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 4 : Device.isiPadLandscape ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    @State var refreshID = UUID()
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: viewModel.media.name.localized())
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.mediaItem.indices, id: \.self) { index in
                            DefaultDesign.MovieCard(movies: viewModel.mediaItem[index])
                                .onAppear() {
                                    self.loadMoreIfNeeded(currentItem: index)
                                }
                        }
                    }
                    .id(refreshID)
                }
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !viewModel.isLoading, currentItem == viewModel.mediaItem.count - 5 else { return }
        viewModel.manageAPIs()
    }
}

#Preview {
    MovieListingScreen(viewModel: MovieListingViewModel())
}
