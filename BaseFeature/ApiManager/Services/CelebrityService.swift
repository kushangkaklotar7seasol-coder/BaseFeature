//
//  CelebrityService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 13/07/26.
//

import Foundation
import Alamofire

class CelebrityService{
    
    static let shared = { CelebrityService() }()
    
    func celecrityDetailAPI(parameters: [String: Any] = [:],personId: Int, success: @escaping (Int, PersonDetail) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: celebeityDetailUrl+"\(personId)", responseType: PersonDetail.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func topRatedAPI(parameters: [String: Any] = [:], success: @escaping (Int, MovieSearchResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: topRatedMovieUrl, responseType: MovieSearchResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func celebrityMovieAPI(parameters: [String: Any] = [:],personId: Int, success: @escaping (Int, PersonMovieCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: celebeityDetailUrl+"\(personId)/" + celebrityMovieUrl, responseType: PersonMovieCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func celebrityTvSeriesAPI(parameters: [String: Any] = [:],personId: Int, success: @escaping (Int, PersonTVCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: celebeityDetailUrl+"\(personId)/" + celebritySeriesUrl, responseType: PersonTVCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
