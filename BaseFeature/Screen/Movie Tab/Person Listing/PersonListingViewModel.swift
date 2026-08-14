//
//  PersonListingViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 14/08/26.
//

import Foundation
import Combine

class PersonListingViewModel: ObservableObject {
    @Published var person: CelebrityResponse?
    @Published var isLoading: Bool = false
    
    init(person: CelebrityResponse? = nil) {
        self.person = person
        self.personAPI()
    }
    
    func personAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.celecrityAPI(page: (person?.page ?? 1) + 1) { statusCode, response in
                self.isLoading = false
                for i in response.results {
                    self.person?.results.append(i)
                }
                self.person?.totalPages = response.totalPages
                self.person?.totalResults = response.totalResults
                self.person?.page += 1
            } failure: { error in
                print(error)
                self.isLoading = false
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
}
