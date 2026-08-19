//
//  LanguageViewModel.swift
//  BaseFeature
//
//  Created by Kushang kaklotar on 10/08/26.
//

import Foundation
import Combine

class LanguageViewModel: ObservableObject {
    @Published var isShowBack: Bool
    @Published var selectedLanguage: LanguageItem?
    @Published var languages: [LanguageItem] = [LanguageItem(code: "en"),
                                                LanguageItem(code: "hi"),
                                                LanguageItem(code: "pt-PT"),
                                                LanguageItem(code: "it"),
                                                LanguageItem(code: "es"),
                                                LanguageItem(code: "da"),
                                                LanguageItem(code: "tr"),
                                                LanguageItem(code: "fr"),
                                                LanguageItem(code: "ja"),
                                                LanguageItem(code: "nl"),
                                                LanguageItem(code: "ko"),
                                                LanguageItem(code: "zh-Hans"),
                                                LanguageItem(code: "ru"),
                                                LanguageItem(code: "de")]
    
    init(isShowBack: Bool = true){
        self.isShowBack = isShowBack
        self.selectedLanguage = self.languages.first
    }
    
    // MARK: - Button Click Action -
    func onDoneButtonClick(){
        UserdefaultManager.shared.saveLanguage(self.selectedLanguage ?? LanguageItem(code: "en"))
        if self.isShowBack {
            Router.shared.pop()
        } else {
            Router.shared.updateRoot(.intro)
        }
    }
    
}
