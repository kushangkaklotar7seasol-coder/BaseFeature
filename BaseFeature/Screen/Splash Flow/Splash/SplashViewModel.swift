//
//  SplashViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import Foundation
import Combine
import AWSCore

class SplashViewModel: ObservableObject {
    
    func navigationManager() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             let onBoarding = UserdefaultManager.shared.getIntro()
            let language = UserdefaultManager.shared.getLanguage()
            
            if language == nil {
                Router.shared.updateRoot(.language(isShowBackButton: false))
                return
            }
            
            if onBoarding == 0 {
                Router.shared.updateRoot(.tab)
                return
            }
            
            Router.shared.updateRoot(.intro)
        }
    }
    
    func requestTrackingPermission(completion: (() -> Void)? = nil) {
        
        UserDefaults.standard.set(true, forKey: userdefaultKey.hasShownConsent)
        
        let credentials = AWSStaticCredentialsProvider(accessKey: ACCESS, secretKey: SECRET)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.EUWest1, credentialsProvider: credentials)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        AdsManager.shared.requestForConsentForm { _ in
            DispatchQueue.main.async{
                completion?()
            }
        }
    }
    
    func webservice_getJSON_api(completion: (() -> Void)? = nil) {

        guard let url = URL(string: generalInfoUrl) else {
            print("invalid url")
            Toast.shared.show(message: "invalid url, please reopen the application", type: .error)
            DispatchQueue.main.async {
                completion?()
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil

        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Error:- \(error.localizedDescription)")
                DispatchQueue.main.async { completion?() }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response")
                DispatchQueue.main.async { completion?() }
                return
            }

            guard let data = data else {
                Toast.shared.show(message: "No Data Found", type: .error)
                DispatchQueue.main.async { completion?() }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                    
                    bannerId = json["bannerId"] as? String ?? ""
                    nativeId = json["nativeId"] as? String ?? ""
                    interstialId = json["interstialId"] as? String ?? ""
                    appopenId = json["appopenId"] as? String ?? ""
                    rewardId = json["rewardId"] as? String ?? ""
                    
                    addButtonColor = json["addButtonColor"] as? String ?? "#FA5026"
                    
                    adsPlus = 0
                    adsCount = Int(json["afterClick"] as? String ?? "2") ?? 2
                    
                    if let result = json["extraFields"] as? [String: Any] {
                        let result  = result
                        
                        proxiUrl = result["appjson"] as? String ?? ""
                        isYoutubeEnabled = result["isYoutubeEnabled"] as? String == "false" ? false : true
                    }
                }
                DispatchQueue.main.async { completion?() }
                
            } catch {
                print("❌ JSON Parse Error:", error.localizedDescription)
                Toast.shared.show(message: "Json passing error", type: .error)
                DispatchQueue.main.async { completion?() }
            }
        }

        task.resume()
    }
}
