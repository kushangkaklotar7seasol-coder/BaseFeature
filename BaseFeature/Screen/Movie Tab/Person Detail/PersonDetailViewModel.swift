//
//  PersonDetailViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine

class PersonDetailViewModel: ObservableObject {
    @Published var personalDetail: [PersonalDetail] = []
    @Published var isLoading = false
    @Published var celebrityDetail: PersonDetail?
    @Published var birthday: String?
    @Published var movieCredits: MediaBunch?
    @Published var seriesCredits: MediaBunch?
    @Published var moviesBunch: [MediaBunch] = []
    @Published var isViewAllSheet: Bool = false
    @Published var selectedSegment = 0
    @Published var type: Int = 0 //0=Movie, 1=Series
    
    var celebrityId: Int
    
    init(celebrityId: Int? = 122822) {
        self.celebrityId = celebrityId ?? 0
        self.celebrotyDetailAPI()
    }
    
    func celebrotyDetailAPI() {
        if Utility.isInternetAvailable() {
            CelebrityService.shared.celecrityDetailAPI(personId: self.celebrityId) { statusCode, response in
                self.celebrityDetail = response
                
                if let birthDay = self.celebrityDetail?.birthday {
                    self.birthday = birthDay
                }
                
                if let placeBirth = self.celebrityDetail?.placeOfBirth {
                    self.personalDetail.append(PersonalDetail(id: 1, name: "Strings.birthPlace", value: placeBirth))
                }
                
                if let bornYear = self.celebrityDetail?.birthday?.prefix(4) {
                    let currentYear = Calendar.current.component(.year, from: Date())
                    self.personalDetail.append(PersonalDetail(id: 2, name: "Strings.age", value: "\(currentYear - (Int(bornYear) ?? 0))"))
                }
                
                if let department = self.celebrityDetail?.knownForDepartment {
                    self.personalDetail.append(PersonalDetail(id: 3, name: "Strings.department", value: department))
                }
                
                self.moviesAPI()
            } failure: { error in
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func moviesAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            CelebrityService.shared.celebrityMovieAPI(personId: self.celebrityId) { statusCode, response in
                self.isLoading = false
//                self.movieCredits = response
                if !response.cast.isEmpty {
                    self.movieCredits = MediaBunch(id: 0, name: "MOVIE", type: .nothing, media: MediaCredits(page: 0, totalPages: 0, totalResults: 0, results: response.cast))
                } else {
                    self.selectedSegment = 1
                }
                self.tvShowAPI()
            } failure: { error in
                self.isLoading = false
                print(error)
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
    
    func tvShowAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            CelebrityService.shared.celebrityTvSeriesAPI(personId: self.celebrityId) { statusCode, response in
                self.isLoading = false
//                self.seriesCredits = response
//                self.moviesBunchNewRelease = MediaBunch(id: 0, name: "New Relese", type: .NewRelesesMovie, media: response)
                if !response.cast.isEmpty {
                    self.seriesCredits = MediaBunch(id: 0, name: "SERIES", type: .nothing, media: MediaCredits(page: 0, totalPages: 0, totalResults: 0, results: response.cast))
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
