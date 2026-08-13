//
//  DiscoverService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation
import Alamofire

class DiscoverService {
    
    static let shared = { DiscoverService() }()
    
    func newReleaseAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: newReleaseUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func populerAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: populerUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func topRatedAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: topRatedUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func airingTodayAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: airingTodayUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func topRatedSeriesAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: topRatedSeriesUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func populerSeriesAPI(parameters: [String: Any] = [:], page: Int = 1, success: @escaping (Int, MediaCredits) -> (), failure: @escaping (String) -> ()) {
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: populerSeriesUrl+String(page), responseType: MediaCredits.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
}
