//
//  UserdefaultManager.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation

class UserdefaultManager {
    static var shared = UserdefaultManager()
    private let defaults = UserDefaults.standard
    
    private let languageKey = "SELECTED_LANGUAGE"
    private let onBoardingKey = "ONBOARDING"
    private let puzzleKey = "PUZZLE"
    
    // MARK: - Language -
    func saveLanguage(_ selectedLanguage: LanguageItem){
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(selectedLanguage){
            defaults.set(encodedUser, forKey: self.languageKey)
        }
    }
    
    func getLanguage() -> LanguageItem? {
        if let savedUser = defaults.object(forKey: self.languageKey) as? Data {
            let decoder = JSONDecoder()
            if let savedUser = try? decoder.decode(LanguageItem.self, from: savedUser){
                return savedUser
            }
        }
        return nil
    }
    
    func removeLanguage(){
        self.defaults.removeObject(forKey: self.languageKey)
    }
//    
//    // MARK: - Deshboard -
    func saveIntro(_ navigationKey: Int) {
        self.defaults.set(navigationKey, forKey: self.onBoardingKey)
    }
    
    func getIntro() -> Int? {
        return defaults.object(forKey: self.onBoardingKey) as? Int ?? nil
    }
    
//    // MARK: - Puzzle
//    func savePuzzle(_ puzzle: [Puzzle]){
//        let encoder = JSONEncoder()
//        if let encodedUser = try? encoder.encode(puzzle){
//            defaults.set(encodedUser, forKey: self.puzzleKey)
//        }
//    }
//    
//    func getPuzzle() -> [Puzzle] {
//        if let savedUser = defaults.object(forKey: self.puzzleKey) as? Data {
//            let decoder = JSONDecoder()
//            if let savedUser = try? decoder.decode([Puzzle].self, from: savedUser){
//                return savedUser
//            }
//        }
//        return []
//    }
}
