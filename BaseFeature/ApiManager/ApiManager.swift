import Alamofire
import UIKit
import Foundation
//import ObjectMapper

class APIManager {
    
    static let shared = { APIManager(baseURL: serverUrl) }()
    
    var baseURL: URL?
    
    required init(baseURL: String) {
        self.baseURL = URL(string: baseURL)
    }
    
//    private func mapResponse<T: Mappable>(
//        _ data: Data,
//        to type: T.Type
//    ) -> T? {
//        let jsonString = String(data: data, encoding: .utf8)
//        return Mapper<T>().map(JSONString: jsonString ?? "")
//    }
    
    func getHeader() -> HTTPHeaders {
        
        var headerDic: HTTPHeaders = [:]
        
        //    if Utility.getUserData() == nil {
//        headerDic = [ "Content-Type": "application/json",
//                      "accept": "application/json"]
        //    }
        //    else {
        //        if let accessToken = Utility.getAccessToken() {
                    headerDic = [
//                        "Content-Type": "application/json",
//                        "Authorization": "Bearer "+accessToken,
                        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZmNlOWE0MGFmNTU5MDM5N2JiYjZjMWIwMGZjOGUxYyIsIm5iZiI6MTc0NjU5Njk0MC41NDIsInN1YiI6IjY4MWFmNDRjYWNkYTE2YzMyNjg1MDhhYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.p-W6BpCTbQXniMiNOYcKHbuOYjsLoBHy7BdcKvrkbiI",
                        "accept": "application/json"
                    ]
        //        }
        //        else {
        //            headerDic = [ "Content-Type": "application/json"]
        //        }
        //    }
        return headerDic
    }
    
    func requestAPIWithParameters<T: Decodable>(
        method: HTTPMethod,
        urlString: String,
        parameters: [String: Any],
        success: @escaping (Int, T) -> (),
        failure: @escaping (String) -> ()
    ) {
        
        if isAppInTestMode {
            print("Headers:", getHeader())
            print("Method:", method)
            print("URL:", urlString)
            print("Parameters:", parameters)
        }
        
        AF.request(
            urlString,
            method: method,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: getHeader()
        )
        .validate()
        .responseData { response in
            
            switch response.result {
                
            case .success(let data):
                
                guard let statusCode = response.response?.statusCode/*, let mappedResponse = self.mapResponse(data, to: Response.self) */ else {
                    failure("Invalid response")
                    return
                }
                
                if (200..<300).contains(statusCode) {
//                    success(statusCode, mappedResponse)
                    print(data)
                }
                else if statusCode == 401 {
                    //Utility.hideIndicator()
//                    Utility.removeUserData()
                    //Utility.setLoginRoot()
//                    failure(mappedResponse.message ?? "")
                }
                else if statusCode == 403 {
//                    success(statusCode, mappedResponse)
                }
                else {
//                    failure(mappedResponse.message ?? "")
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func requestAPIWithGetMethod<T: Decodable>(
        method: HTTPMethod,
        urlString: String,
        responseType: T.Type,
        success: @escaping (Int, T) -> (),
        failure: @escaping (String) -> ()
    ) {
        if isAppInTestMode {
            print(HTTPMethod.self)
            print(urlString)
        }
        
        AF.request(
            urlString,
            method: method,
            headers: getHeader()
        )
        .validate()
        .responseData { response in
            
            switch response.result {
                
            case .success(let data):

                guard let statusCode = response.response?.statusCode else {
                    failure("Invalid response")
                    return
                }
                
                if (200..<300).contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let apiData = try decoder.decode(T.self, from: data)
                        success(statusCode, apiData)
                    } catch let DecodingError.keyNotFound(key, context) {
                        failure("Missing key: \(key.stringValue)")
                        print(context.debugDescription)
                    } catch let DecodingError.typeMismatch(type, context) {
                        failure("Type mismatch: \(type)")
                        print(context.codingPath)
                        print(context.debugDescription)
                    } catch let DecodingError.valueNotFound(value, context) {
                        failure("Value not found: \(value)")
                        print(context.codingPath)
                        print(context.debugDescription)
                    } catch let DecodingError.dataCorrupted(context) {
                        failure("Data corrupted: \(context.debugDescription)")
                    } catch {
                        failure(error.localizedDescription)
                    }
                }
                else if statusCode == 403 {
                    do {
                        let decoder = JSONDecoder()
                        let apiData = try decoder.decode(T.self, from: data)
                        success(statusCode, apiData)
                        
                    } catch {
                        failure("Failed to convert data: \(error.localizedDescription)")
                    }
                }
                else {
                    failure("error")
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func weatherGetAPI<T: Decodable>(
        method: HTTPMethod,
        urlString: String,
        responseType: T.Type,
        success: @escaping (Int, T) -> (),
        failure: @escaping (String) -> ()
    ) {
        if isAppInTestMode {
            print(HTTPMethod.self)
            print(urlString)
        }
        
        AF.request(
            urlString,
            method: method,
        )
        .validate()
        .responseData { response in
            
            switch response.result {
                
            case .success(let data):

                guard let statusCode = response.response?.statusCode else {
                    failure("Invalid response")
                    return
                }
                
                if (200..<300).contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let apiData = try decoder.decode(T.self, from: data)
                        success(statusCode, apiData)
                    } catch let DecodingError.keyNotFound(key, context) {
                        failure("Missing key: \(key.stringValue)")
                        print(context.debugDescription)
                    } catch let DecodingError.typeMismatch(type, context) {
                        failure("Type mismatch: \(type)")
                        print(context.codingPath)
                        print(context.debugDescription)
                    } catch let DecodingError.valueNotFound(value, context) {
                        failure("Value not found: \(value)")
                        print(context.codingPath)
                        print(context.debugDescription)
                    } catch let DecodingError.dataCorrupted(context) {
                        failure("Data corrupted: \(context.debugDescription)")
                    } catch {
                        failure(error.localizedDescription)
                    }
                }
                else if statusCode == 403 {
                    do {
                        let decoder = JSONDecoder()
                        let apiData = try decoder.decode(T.self, from: data)
                        success(statusCode, apiData)
                        
                    } catch {
                        failure("Failed to convert data: \(error.localizedDescription)")
                    }
                }
                else {
                    failure("error")
                }
                
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func downloadImage(url: URL,
                       success: @escaping (UIImage) -> (),
                       failure: @escaping (String) -> ()) {
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            
            success(image)
            
        }.resume()
    }
    
}
