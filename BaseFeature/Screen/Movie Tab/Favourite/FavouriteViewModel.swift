//
//  FavouriteViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine

class FavouriteViewModel: ObservableObject {
    @Published var movies: [MediaItem] = []
    @Published var series: [MediaItem] = []
    
    init() {
        for i in database.fetchMovies() {
            if i.isMovie == 1 {
                self.movies.append(i)
            } else {
                self.series.append(i)
            }
        }
    }
    
    func fetchMovie(){
        for i in database.fetchMovies() {
            if i.isMovie == 1 {
                self.movies.append(i)
            }
        }
    }
    
    func fetchSeries(){
        for i in database.fetchMovies() {
            if i.isMovie != 1 {
                self.series.append(i)
            }
        }
    }
}
