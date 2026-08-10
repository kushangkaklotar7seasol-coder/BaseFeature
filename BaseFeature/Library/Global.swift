//
//  Global.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation
import UIKit

let appName = "Movie Box"

var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
let isAppInTestMode = true

let imageUrl = "https://image.tmdb.org/t/p/w600_and_h900_face"
public let ACCESS = "AKIA2FCATE7MLGSZBHML"
public let SECRET = "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"

// MARK: - Ads manager -
let isPro = false
var bannerId = ""
var nativeId = ""
var appopenId = ""
var rewardId = ""
var interstialId = ""
var addButtonColor = ""
var smallNativeBannerId = ""
var adsCount = 0
var adsPlus = 0
var sholdShowAppOpenAd = true
let isFirstLaunchKey = "isFirstLaunch"

enum userdefaultKey {
    static let hasShownConsent = "hasShownConsent"
}

// MARK: - Supporting class
let database = SQLiteManager.shared

var isYoutubeEnabled = false


// MARK: - Default message -
let noInternet = "Please check you're internet connection!"

struct AppInfo {
    static let privacyPolicy       = "https://evanrozario.blogspot.com/2026/07/privacy-policy.html"
    static let termsOfUse          = "https://evanrozario.blogspot.com/2026/07/terms-conditions.html"
    static let shareApp            = "https://apps.apple.com/app/id\(appID)"
    static let appLink             = "https://itunes.apple.com/app/id\(appID)"
    static let rateApp             = "https://apps.apple.com/app/id\(appID)?action=write-review"
    static var appID               = "6793888974"
}


struct Device {
    static var topSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.top ?? 0
    }
    
    static var bottomSafeArea: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    }
    
    private static var nativeScale: CGFloat {
        UIScreen.main.nativeScale
    }
    
    static var portraitWidth: CGFloat {
        let screen = UIScreen.main
        return screen.nativeBounds.width / nativeScale
    }
    
    static var portraitHeight: CGFloat {
        let screen = UIScreen.main
        return screen.nativeBounds.height / nativeScale
    }
    
    static var width: CGFloat {
        currentSize.width
    }
    
    static var height: CGFloat {
        currentSize.height
    }
    
    static var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPortrait: Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
    
    static var isLandscape: Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }
    
    static var isiPadLandscape: Bool {
        if isIpad {
            return currentSize.width > currentSize.height
        } else {
            return false
        }
    }
 
    static var isiPadPortrait: Bool {
        if isIpad {
            return currentSize.height > currentSize.width
        } else {
            return false
        }
    }
    
    static var currentSize: CGSize {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return UIScreen.main.bounds.size
        }
        
        let size = window.bounds.size
        
        if isIpad {
            // On iPad use actual current orientation size
            return size
        } else {
            // Keep portrait logic for iPhone if needed
            return CGSize(
                width: min(size.width, size.height),
                height: max(size.width, size.height)
            )
        }
    }
}
