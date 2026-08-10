//
//  String+Entension.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation

extension String {
    func localized() -> String {
        let loc = UserdefaultManager.shared.getLanguage()?.code ?? "en"
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    func localizedLan(loc: String) -> String {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
