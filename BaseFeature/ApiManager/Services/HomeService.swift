//
//  HomeService.swift
//  Movies Guide
//
//  Created by Kushang  on 19/12/25.
//

import Foundation
import Alamofire

class HomeServices{
    
    static let shared = { HomeServices() }()
    
    func topRatedAPI(parameters: [String: Any] = [:], success: @escaping (Int, MovieSearchResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: topRatedMovieUrl, responseType: MovieSearchResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func celecrityAPI(parameters: [String: Any] = [:],page: Int, success: @escaping (Int, CelebrityResponse) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: celebrityUrl+"\(page)", responseType: CelebrityResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func upCommingdAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: upcommingMovieUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func onTheAirAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: onTheAirUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func searchMovieAPI(parameters: [String: Any] = [:],text: String,page: Int, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        let url = searchUrl+text+"&page=\(page)"
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: url, responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func searchSeriesAPI(parameters: [String: Any] = [:],text: String,page: Int, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        let url = searchSeriesUrl+text+"&page=\(page)"
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: url, responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func generalInfoAPI(parameters: [String: Any] = [:], success: @escaping (Int, AppConfig) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: generalInfoUrl, responseType: AppConfig.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
