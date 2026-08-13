//
//  WallpaperService.swift
//  Korvani
//
//  Created by Kushang kaklotar on 15/07/26.
//

import Foundation
import Alamofire
import UIKit

class WallpaperService {
    
    static let shared = { WallpaperService() }()
    
    func wallpaperAPI(parameters: [String: Any] = [:], page: Int, success: @escaping (Int, WallpaperListResponse) -> (), failure: @escaping (String) -> ()) {
        
        APIManager.shared.requestAPIWithGetMethod(method: .get, urlString: wallpapaerUrl+String(page), responseType: WallpaperListResponse.self) { statusCode, response in
            success(statusCode, response)
        } failure: { error in
            failure(error)
        }
    }
    
    func downloadImage(url: URL, success: @escaping (UIImage) -> (), failure: @escaping (String) -> ()){
        APIManager.shared.downloadImage(url: url) { image in
            success(image)
        } failure: { error in
            failure(error)
        }
    }
    
}
