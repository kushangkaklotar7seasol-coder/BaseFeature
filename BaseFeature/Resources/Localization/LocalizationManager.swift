//
//  LocalizationManager.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 24/07/26.
//

import Foundation
import Combine
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") var selectedLanguage: String = (UserdefaultManager.shared.getLanguage()?.code ?? "en") {
        didSet {
            Bundle.setLanguage(selectedLanguage)
        }
    }
    
    init() {
        Bundle.setLanguage(selectedLanguage) // set bundle correctly on cold launch too
    }
    
    func changeLanguage(languageCode: String){
        Bundle.setLanguage(languageCode)
        selectedLanguage = languageCode
    }
}

extension Bundle {
    static var localizedBundle: Bundle = Bundle.main
    
    static func setLanguage(_ language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        localizedBundle = path.flatMap { Bundle(path: $0) } ?? Bundle.main
    }
}

struct LanguageItem: Identifiable, Codable {
    let id = UUID()
    let code: String

    var icon: String {
        switch code {
        case "en": return "ic_english"
        case "hi": return "ic_hindi"
        case "de": return "ic_german"
        case "pt-PT": return "ic_portuguese"
        case "it": return "ic_italian"
        case "es": return "ic_spanish"
        case "da": return "ic_danish"
        case "tr": return "ic_turkish"
        case "fr": return "ic_french"
        case "ja": return "ic_japanese"
        case "nl": return "ic_dutch"
        case "ko": return "ic_korean"
        case "zh-Hans": return "ic_chinese"
        case "ru": return "ic_russian"
        default: return ""
        }
    }
    
    var iconCode: String {
        switch code {
        case "en": return "EN"
        case "hi": return "HI"
        case "de": return "DE"
        case "pt-PT": return "PT"
        case "it": return "IT"
        case "es": return "ES"
        case "da": return "DA"
        case "tr": return "TR"
        case "fr": return "FR"
        case "ja": return "JA"
        case "nl": return "NL"
        case "ko": return "KO"
        case "zh-Hans": return "CH"
        case "ru": return "RU"
        default: return ""
        }
    }

    var subTitle: String {
        switch code {
        case "en": return "English"
        case "hi": return "Hindi"
        case "de": return "German"
        case "pt-PT": return "Portuguese"
        case "it": return "Italian"
        case "es": return "Spanish"
        case "da": return "Danish"
        case "tr": return "Turkish"
        case "fr": return "French"
        case "ja": return "Japanese"
        case "nl": return "Dutch"
        case "ko": return "Korean"
        case "zh-Hans": return "Chinese"
        case "ru": return "Russian"
        default: return ""
        }
    }

    var title: String {
        switch code {
        case "en": return "English"
        case "hi": return "हिंदी"
        case "de": return "Deutsch"
        case "pt-PT": return "Português"
        case "it": return "Italiano"
        case "es": return "Española"
        case "da": return "dansk"
        case "tr": return "Türkçe"
        case "fr": return "Français"
        case "ja": return "日本語"
        case "nl": return "Nederlands"
        case "ko": return "한국인"
        case "zh-Hans": return "中国人"
        case "ru": return "Русский"
        default: return ""
        }
    }
}
