//
//  MovieListingViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine

class MovieListingViewModel: ObservableObject {
    @Published var media: MediaBunch
    
    @Published var mediaCredits: MediaCredits?
    @Published var mediaItem: [MediaItem] = []
    @Published var isLoading = false
    
    init(media: MediaBunch? = nil) {
        self.media = media ?? MediaBunch(id: 0, name: "", type: .TopRatedMovie, media: MediaCredits(page: 0, totalPages: 0, totalResults: 0, results: []))
        
        self.mediaCredits = media?.media
        self.mediaItem = media?.media.results ?? []
    }
    
    func manageAPIs(){
        switch self.media.type {
        case .NewRelesesMovie:
            self.newReleaseAPI()
        case .TopRatedMovie:
            self.topRatedAPI()
        case .MostPopulerMovie:
            self.populerAPI()
        case .airingTodaySeries:
            self.airingTodayAPI()
        case .topRatedSeries:
            self.topRatedSeriesAPI()
        case .mostPopulerSeries:
            self.populerSeriesAPI()
        case .upcommingMovie:
            self.upcomingMovieAPI()
        case .onTheAirSeries:
            self.onTheAirSeriesAPI()
        case .nothing:
            print("No paggination data found")
        }
    }
    
    // MARK: - API Call's -
    func newReleaseAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.newReleaseAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func topRatedAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func populerAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func airingTodayAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.airingTodayAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func topRatedSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.topRatedSeriesAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func populerSeriesAPI() {
        if Utility.isInternetAvailable() {
            DiscoverService.shared.populerSeriesAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func upcomingMovieAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.upCommingdAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                self.isLoading = false
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func onTheAirSeriesAPI() {
        if Utility.isInternetAvailable() {
            isLoading = true
            HomeServices.shared.onTheAirAPI(page: (self.mediaCredits?.page ?? 0)+1) { statusCode, response in
                self.mediaCredits = response
                self.isLoading = false
                for i in response.results {
                    self.mediaItem.append(i)
                }
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
}
