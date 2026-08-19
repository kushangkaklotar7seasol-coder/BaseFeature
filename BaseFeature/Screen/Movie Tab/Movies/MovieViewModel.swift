//
//  MovieViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 13/08/26.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var topRatedMovie: [Movie] = []
    @Published var celebrity: CelebrityResponse?
    @Published var moviesBunchNewRelease: MediaBunch?
    @Published var moviesBunchUpcoming: MediaBunch?
    @Published var moviesBunchOnAir: MediaBunch?
    @Published var moviesBunchAiringToday: MediaBunch?

    init() {
        self.topRatedMovieAPI()
    }
    
    // MARK: - API Call's -
    func topRatedMovieAPI() {
        if Utility.isInternetAvailable() {
            HomeServices.shared.topRatedAPI { statusCode, response in
                let movieData = response.results.prefix(5)
                self.topRatedMovie = Array(repeating: movieData, count: 100).flatMap { $0 }
                self.upcomingMovieAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func celebrityAPI() {
        if Utility.isInternetAvailable() {
            HomeServices.shared.celecrityAPI(page: 1) { statusCode, response in
                self.celebrity = response
                self.newReleaseAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func newReleaseAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.newReleaseAPI { statusCode, response in
                self.moviesBunchNewRelease = MediaBunch(id: 0, name: "NEW_RELESE", type: .NewRelesesMovie, media: response)
                self.onTheAirSeriesAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func upcomingMovieAPI() {
        if Utility.isInternetAvailable() {
            HomeServices.shared.upCommingdAPI { statusCode, response in
                self.moviesBunchUpcoming = MediaBunch(id: 0, name: "UPCOMING", type: .upcommingMovie, media: response)
                self.celebrityAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func onTheAirSeriesAPI() {
        if Utility.isInternetAvailable() {
            HomeServices.shared.onTheAirAPI { statusCode, response in
                self.moviesBunchOnAir = MediaBunch(id: 1, name: "ON_AIR", type: .onTheAirSeries, media: response)
                self.airingTodayAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func airingTodayAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.airingTodayAPI { statusCode, response in
                self.moviesBunchAiringToday = MediaBunch(id: 0, name: "AIRING_TODAY", type: .airingTodaySeries, media: response)
            } failure: { error in
                print(error)
            }
        } else {
            print("No internet connected")
        }
    }
}
