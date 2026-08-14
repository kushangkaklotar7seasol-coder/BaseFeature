//
//  FavouriteScreen.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import SwiftUI

struct FavouriteScreen: View {
    @StateObject var viewModel = FavouriteViewModel()
    @State var selectedIndex = 0
    var columns: [GridItem] {
        let count = Device.isiPadPortrait ? 4 : Device.isiPadLandscape ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
    }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: "Favourite")
                
                CustomSegmentedControl(preselectedIndex: $selectedIndex)
                
                if selectedIndex == 0 {
                    if !viewModel.movies.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.movies.indices, id: \.self) { index in
                                    let movie = viewModel.movies[index]
                                    DefaultDesign.MovieCard(movies: movie, onLike: {_ in
                                        viewModel.movies.removeAll(where: {$0.id == movie.id})
                                        DispatchQueue.main.async {
                                            viewModel.fetchMovie()
                                        }
                                    })
                                    .id(movie.id)
                                }
                            }
                        }
                        
                    } else {
                        VStack {
                            Spacer()
                            Image("ic_no_favourite")
                                .resizable()
                                .frame(width: 120, height: 120, alignment: .center)
                            
                            Text("Nothing Here Yet")
                                .foregroundColor(.whiteColour)
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Your favorite movies will appear here.")
                                .foregroundColor(.grayColour)
                                .font(.system(size: 14, weight: .regular))
                            
                            Spacer()
                        }
                    }
                } else {
                    if !viewModel.series.isEmpty {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns) {
                                ForEach(viewModel.series.indices, id: \.self) { index in
                                    let movie = viewModel.series[index]
                                    DefaultDesign.MovieCard(movies: movie, onLike: {_ in
                                        viewModel.series.removeAll(where: {$0.id == movie.id})
                                        DispatchQueue.main.async {
                                            viewModel.fetchMovie()
                                        }
                                    })
                                    .id(movie.id)
                                }
                            }
                        }
                        
                    } else {
                        VStack {
                            Spacer()
                            Image("ic_no_favourite")
                                .resizable()
                                .frame(width: 120, height: 120, alignment: .center)
                            
                            Text("Nothing Here Yet")
                                .foregroundColor(.whiteColour)
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Your favorite TV shows will appear here.")
                                .foregroundColor(.grayColour)
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    FavouriteScreen()
}
