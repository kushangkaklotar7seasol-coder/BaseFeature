//
//  MovieDetailViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var movieDetail: MediaDetail?
    @Published var movieCredits: MovieCredits?
    @Published var movieImage: MovieImages?
    @Published var movieVideo: MovieVideos?
    @Published var directorDetail: CrewMember?
    
    @Published var selectedCastOption: Int = 0
    @Published var selectedMediaOption: Int = 0
    
    @Published var isLiked = false
    
    @Published var isYoutubeVideo = false
    @Published var youtubeUrl = ""
    
    @Published var isShowAllCast = false
    
    var movieId: Int?
    @Published var isMovie: Bool?
    @Published var personalInformation: [PersonalDetail] = []
    
    init(movieId: Int = 1368337, isMovie: Bool = true) {
        self.movieId = movieId
        self.isMovie = isMovie
        if isMovie {
            self.movieDetails()
        } else {
            self.seriesDetails()
        }
    }
    
    // MARK: - API Call's
    func movieDetails() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieDetail(id: self.movieId ?? 0) { statusCode, response in
                self.movieDetail = response
                self.isLiked = database.isMovieLiked(id: self.movieId ?? 0)
                
//                if let status = self.movieDetail?.status {
//                    self.personalInformation.append(PersonalDetail(id: 0, name: Strings.status, value: status))
//                }
//                
//                if let language = self.movieDetail?.spokenLanguages.first?.englishName {
//                    self.personalInformation.append(PersonalDetail(id: 1, name: Strings.language, value: language))
//                }
//                
//                if let runtime = self.movieDetail?.runtime, runtime != 0 {
//                    self.personalInformation.append(PersonalDetail(id: 2, name: Strings.runtime, value: "\(runtime)"))
//                }
//                
//                if let revenue = self.movieDetail?.revenue, revenue != 0 {
//                    self.personalInformation.append(PersonalDetail(id: 3, name: Strings.revenue, value: "\(revenue)"))
//                }
                
                self.movieVideoAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func castAndCrewAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.castAndCrew(id: self.movieId ?? 0) { statusCode, response in
                self.movieCredits = response
                //Directing
                self.directorDetail = response.crew.first(where: {$0.department == "Directing"})
                self.movieImageAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func movieImageAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieImage(id: self.movieId ?? 0) { statusCode, response in
                self.movieImage = response
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func movieVideoAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.movieVideo(id: self.movieId ?? 0) { statusCode, response in
                self.movieVideo = response
                self.setTrailer()
                self.castAndCrewAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func setTrailer(){
        var videoKey: [Video] = []
        videoKey = self.movieVideo?.results.filter({$0.type == "Trailer"}) ?? []
        if videoKey.isEmpty {
            videoKey = self.movieVideo?.results.filter({$0.type == "Teaser"}) ?? []
        }
        if videoKey.isEmpty {
            if let myRes = self.movieVideo?.results.first {
                videoKey.append(myRes)
            }
        }
        if let key = videoKey.first?.key {
            self.youtubeUrl = "https://www.youtube.com/watch?v=\(key)"
        } else {
            self.youtubeUrl = "https://www.youtube.com/results?search_query=\(self.movieDetail?.name ?? self.movieDetail?.title ?? "") Trailer"
        }
        
    }
    
    func seriesDetails() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesDetail(id: self.movieId ?? 0) { statusCode, response in
                print(response)
                self.movieDetail = response
                self.isLiked = database.isMovieLiked(id: self.movieId ?? 0)
                
//                if let status = self.movieDetail?.status {
//                    self.personalInformation.append(PersonalDetail(id: 0, name: Strings.status, value: status))
//                }
//                
//                if let language = self.movieDetail?.spokenLanguages.first?.englishName {
//                    self.personalInformation.append(PersonalDetail(id: 1, name: Strings.language, value: language))
//                }
//                
//                if let runtime = self.movieDetail?.runtime, runtime != 0 {
//                    self.personalInformation.append(PersonalDetail(id: 2, name: Strings.runtime, value: "\(runtime)"))
//                }
//                
//                if let revenue = self.movieDetail?.revenue, revenue != 0 {
//                    self.personalInformation.append(PersonalDetail(id: 3, name: Strings.revenue, value: "\(revenue)"))
//                }
//                
//                if let season = self.movieDetail?.seasons?.count {
//                    self.personalInformation.append(PersonalDetail(id: 4, name: Strings.season, value: "\(season > 1 ? season-1 : season)"))
//                }
                
                self.seriesVideoAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func seriesCastAndCrew() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesCastAndCrew(id: self.movieId ?? 0) { statusCode, response in
                self.movieCredits = response
                self.seriesImageAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func seriesImageAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesImage(id: self.movieId ?? 0) { statusCode, response in
                self.movieImage = response
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func seriesVideoAPI() {
        if Utility.isInternetAvailable() {
            MovieDetailService.shared.seriesVideo(id: self.movieId ?? 0) { statusCode, response in
                self.movieVideo = response
                var videoKey: [Video] = []
                videoKey = response.results.filter({$0.type == "Trailer"})
                if videoKey.isEmpty {
                    videoKey = response.results.filter({$0.type == "Teaser"})
                }
                if videoKey.isEmpty {
                    if let myRes = response.results.first {
                        videoKey.append(myRes)
                    }
                }
                if let key = videoKey.first?.key {
                    self.youtubeUrl = "https://www.youtube.com/watch?v=\(key)"
                } else {
                    self.youtubeUrl = "https://www.youtube.com/results?search_query=\(self.movieDetail?.name ?? self.movieDetail?.title ?? "") Trailer"
                }
                
                self.seriesCastAndCrew()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func manageLike() {
//        if self.isLiked {
//            database.removeMovie(id: movieId ?? 0)
//        } else {
//            database.addMovie(MediaItem(adult: false, backdropPath: "", genreIds: [], id: movieId ?? 0, originalLanguage: "", overview: "", popularity: 0.0, posterPath: movieDetail?.posterPath, softcore: false, voteAverage: movieDetail?.voteAverage ?? 0.0, voteCount: 0, title: movieDetail?.title, originalTitle: "", releaseDate: "", video: false, name: movieDetail?.title, originalName: "", firstAirDate: movieDetail?.releaseDate, originCountry: [], character: "", creditId: "", episodeCount: 0, firstCreditAirDate: "", isMovie: self.isMovie ?? true ? 1 : 0))
//        }
//        self.isLiked.toggle()
    }
    
    func translatedText() -> String {
//        return """
//         \(Strings.shareText1) \(self.movieDetail?.name ?? self.movieDetail?.title ?? "")
//         \(Strings.shareText2)
//        """
        return ""
    }
}
