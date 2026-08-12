//
//  Structure.swift
//  Movie Box
//
//  Created by Kushang kaklotar on 24/07/26.
//

import Foundation

struct OnBordingInfo {
    let id: Int
    var image: String
    var name: String
    var name2: String
    var info: String
    var moreInfo: String? = nil
}

struct PersonalDetail {
    let id: Int
    var name: String
    var value: String
}

struct Notes: Codable, Identifiable, Hashable {
    var id = UUID()
    var createdDate: Date
    var editDate: Date
    var name: String
    var notes: String
    var isPined: Bool
}

struct StrogeInfo {
    var id: Int
    var name: String
    var storage: String
    var percent: Double
}
