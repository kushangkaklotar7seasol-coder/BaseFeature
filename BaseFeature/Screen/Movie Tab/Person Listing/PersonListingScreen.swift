//
//  PersonListingScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI

struct PersonListingScreen: View {
    @StateObject var viewModel: PersonListingViewModel
    @State private var refreshID = UUID()
    
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 5 : Device.isiPadLandscape ? 6 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "CELEBRITY")
                    .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    if let array = viewModel.person?.results {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(Array(array.enumerated()), id: \.offset) { index, person in
                                DefaultDesign.PersonPoster(id: person.id, url: person.profilePath ?? "", name: person.name)
                                    .onAppear {
                                        loadMoreIfNeeded(currentItem: index)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .id(refreshID)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                }
            }
        }
        .defaultPage()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard let totalCount = viewModel.person?.results.count else { return }
        guard !viewModel.isLoading else { return }
        let thresholdIndex = max(0, totalCount - 4)
        
        if currentItem >= thresholdIndex {
            viewModel.personAPI()
        }
    }
}

#Preview {
    PersonListingScreen(viewModel: PersonListingViewModel())
}
