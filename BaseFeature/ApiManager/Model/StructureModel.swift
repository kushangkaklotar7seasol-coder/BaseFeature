//
//  StructureModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 16/07/26.
//

import Foundation

enum DiscoverAPIType {
    case NewRelesesMovie, TopRatedMovie, MostPopulerMovie, airingTodaySeries, topRatedSeries, mostPopulerSeries, upcommingMovie, onTheAirSeries, nothing
}

struct MediaBunch: Hashable {
    let id: Int
    var name: String
    var type: DiscoverAPIType
    var media: MediaCredits
}

struct QuichToolsModel {
    let id: Int
    var name: String
    var image: String
    var info: String
}
