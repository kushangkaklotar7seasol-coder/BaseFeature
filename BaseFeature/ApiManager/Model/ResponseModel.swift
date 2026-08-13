//
//  ResponseModel.swift
//  Mems
//
//  Created by iMac on 03/07/24.
//

import Foundation

// MARK: - TopRated movie -
struct MovieSearchResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
 
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
 
// MARK: - Movie -
struct Movie: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let softcore: Bool
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
 
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case softcore
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
 
// MARK: - Celebrity -
struct CelebrityResponse: Codable, Hashable {
    var page: Int
    var results: [Celebrity]
    let totalPages: Int
    let totalResults: Int
 
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
 
// MARK: - Person -
struct Celebrity: Codable, Identifiable, Hashable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
 
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
    }
}

// MARK: - Person Details -
struct PersonDetail: Codable, Identifiable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbId: String?
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
 
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbId = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

// MARK: - Celebrity related movie -
struct PersonMovieCredits: Codable {
    let cast: [MediaItem]
    let id: Int
}

struct PersonTVCredits: Codable {
    let cast: [MediaItem]
    let id: Int
}

struct TVCastCredit: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let firstAirDate: String?
    let softcore: Bool
    let name: String
    let voteAverage: Double
    let voteCount: Int
    let character: String
    let creditId: String
    let episodeCount: Int
    let firstCreditAirDate: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case softcore
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditId = "credit_id"
        case episodeCount = "episode_count"
        case firstCreditAirDate = "first_credit_air_date"
    }
}

struct MediaCredits: Codable, Hashable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    var results: [MediaItem]
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MediaItem: Codable, Identifiable, Hashable {
    // Shared fields
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let softcore: Bool
    let voteAverage: Double
    let voteCount: Int
 
    // Movie-only fields
    let title: String?
    let originalTitle: String?
    let releaseDate: String?
    let video: Bool?
 
    // TV-only fields
    let name: String?
    let originalName: String?
    let firstAirDate: String?
    let originCountry: [String]?
 
    // TV credit-only fields (present when this item comes from a person's TV credits)
    let character: String?
    let creditId: String?
    let episodeCount: Int?
    let firstCreditAirDate: String?
    
    var isMovie: Int? // 1=Movie, 0=Series
    var isMovieLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case overview
        case popularity
        case posterPath = "poster_path"
        case softcore
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
 
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video
 
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
 
        case character
        case creditId = "credit_id"
        case episodeCount = "episode_count"
        case firstCreditAirDate = "first_credit_air_date"
    }
}

// MARK: - Movie Details -

//struct MovieDetailModel: Codable, Identifiable {
//    let adult: Bool
//    let backdropPath: String?
//    let belongsToCollection: Collection?
//    let budget: Int
//    let genres: [Genre]
//    let homepage: String?
//    let id: Int
//    let imdbId: String?
//    let originCountry: [String]
//    let originalLanguage: String
//    let originalTitle: String
//    let overview: String
//    let popularity: Double
//    let posterPath: String?
//    let productionCompanies: [ProductionCompany]
//    let productionCountries: [ProductionCountry]
//    let releaseDate: String
//    let revenue: Int
//    let runtime: Int?
//    let softcore: Bool
//    let spokenLanguages: [SpokenLanguage]
//    let status: String
//    let tagline: String?
//    let title: String
//    let video: Bool
//    let voteAverage: Double
//    let voteCount: Int
// 
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case belongsToCollection = "belongs_to_collection"
//        case budget
//        case genres
//        case homepage
//        case id
//        case imdbId = "imdb_id"
//        case originCountry = "origin_country"
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview
//        case popularity
//        case posterPath = "poster_path"
//        case productionCompanies = "production_companies"
//        case productionCountries = "production_countries"
//        case releaseDate = "release_date"
//        case revenue
//        case runtime
//        case softcore
//        case spokenLanguages = "spoken_languages"
//        case status
//        case tagline
//        case title
//        case video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}
// 
//// MARK: - Genre
// 
//struct Genre: Codable, Identifiable {
//    let id: Int
//    let name: String
//}
// 
//// MARK: - Collection
// 
//struct Collection: Codable, Identifiable {
//    let id: Int
//    let name: String
//    let posterPath: String?
//    let backdropPath: String?
// 
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case posterPath = "poster_path"
//        case backdropPath = "backdrop_path"
//    }
//}
// 
//// MARK: - ProductionCompany
// 
//struct ProductionCompany: Codable, Identifiable {
//    let id: Int
//    let logoPath: String?
//    let name: String
//    let originCountry: String
// 
//    enum CodingKeys: String, CodingKey {
//        case id
//        case logoPath = "logo_path"
//        case name
//        case originCountry = "origin_country"
//    }
//}
// 
//// MARK: - ProductionCountry
// 
//struct ProductionCountry: Codable {
//    let iso31661: String
//    let name: String
// 
//    enum CodingKeys: String, CodingKey {
//        case iso31661 = "iso_3166_1"
//        case name
//    }
//}
// 
//// MARK: - SpokenLanguage
// 
//struct SpokenLanguage: Codable {
//    let englishName: String
//    let iso6391: String
//    let name: String
// 
//    enum CodingKeys: String, CodingKey {
//        case englishName = "english_name"
//        case iso6391 = "iso_639_1"
//        case name
//    }
//}
struct MediaDetail: Codable, Identifiable {
    // Shared fields
    let adult: Bool
    let backdropPath: String?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let originCountry: [String]
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let softcore: Bool
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let voteAverage: Double
    let voteCount: Int
 
    // Movie-only fields
    let belongsToCollection: Collection?
    let budget: Int?
    let imdbId: String?
    let originalTitle: String?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let title: String?
    let video: Bool?
 
    // TV-only fields
    let createdBy: [Creator]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let name: String?
    let networks: [Network]?
    let nextEpisodeToAir: Episode?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originalName: String?
    let seasons: [Season]?
    let type: String?
 
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genres
        case homepage
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case softcore
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
 
        case belongsToCollection = "belongs_to_collection"
        case budget
        case imdbId = "imdb_id"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case title
        case video
 
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case networks
        case nextEpisodeToAir = "next_episode_to_air"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originalName = "original_name"
        case seasons
        case type
    }
}
 
// MARK: - Genre
 
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
 
// MARK: - Collection
 
struct Collection: Codable, Identifiable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
 
// MARK: - ProductionCompany
 
struct ProductionCompany: Codable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
 
// MARK: - ProductionCountry
 
struct ProductionCountry: Codable {
    let iso31661: String
    let name: String
 
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
 
// MARK: - SpokenLanguage
 
struct SpokenLanguage: Codable {
    let englishName: String
    let iso6391: String
    let name: String
 
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
 
// MARK: - Creator (TV)
 
struct Creator: Codable, Identifiable {
    let id: Int
    let creditId: String
    let name: String
    let originalName: String
    let gender: Int
    let profilePath: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case creditId = "credit_id"
        case name
        case originalName = "original_name"
        case gender
        case profilePath = "profile_path"
    }
}
 
// MARK: - Network (TV)
 
struct Network: Codable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
 
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
 
// MARK: - Episode (TV: last_episode_to_air / next_episode_to_air)
 
struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let airDate: String?
    let episodeNumber: Int
    let episodeType: String
    let productionCode: String
    let runtime: Int?
    let seasonNumber: Int
    let showId: Int
    let stillPath: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case episodeType = "episode_type"
        case productionCode = "production_code"
        case runtime
        case seasonNumber = "season_number"
        case showId = "show_id"
        case stillPath = "still_path"
    }
}
 
// MARK: - Season (TV)
 
struct Season: Codable, Identifiable {
    let airDate: String?
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double
 
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id
        case name
        case overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}

struct MovieCredits: Codable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}
 
// MARK: - CastMember
 
struct CastMember: Codable, Identifiable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int?
    let character: String
    let creditId: String
    let order: Int
 
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castId = "cast_id"
        case character
        case creditId = "credit_id"
        case order
    }
}
 
// MARK: - CrewMember
 
struct CrewMember: Codable, Identifiable {
    let adult: Bool
    let gender: Int
    let id: Int
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditId: String
    let department: String
    let job: String
 
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department
        case job
    }
}
 

// MARK: - MovieImages
struct MovieImages: Codable {
    let backdrops: [MovieImage]
    let id: Int
    let logos: [MovieImage]
    let posters: [MovieImage]
}
 
// MARK: - MovieImage
 
struct MovieImage: Codable, Hashable {
    let aspectRatio: Double
    let height: Int
    let iso3166_1: String?
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount: Int
    let width: Int
 
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso3166_1 = "iso_3166_1"
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

// MARK: - MovieVideos
 
struct MovieVideos: Codable {
    let id: Int
    let results: [Video]
}
 
// MARK: - Video
 
struct Video: Codable, Identifiable, Hashable {
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let id: String
    let publishedAt: String
 
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case key
        case site
        case size
        case type
        case official
        case id
        case publishedAt = "published_at"
    }
}



// MARK: - Weather -
struct WeatherForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}
 
// MARK: ForecastItem
 
struct ForecastItem: Codable, Identifiable {
    let dt: Int
    let main: MainWeather
    let weather: [WeatherCondition]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Precipitation?
    let snow: Precipitation?
    let sys: Sys
    let dtTxt: String
 
    var id: Int { dt }
 
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case rain
        case snow
        case sys
        case dtTxt = "dt_txt"
    }
}
 
// MARK: MainWeather
 
struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let grndLevel: Int
    let humidity: Int
    let tempKf: Double
    let dewPoint: Double?
 
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
        case dewPoint = "dew_point"
    }
}
 
// MARK: WeatherCondition
 
struct WeatherCondition: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
 
    /// Full icon image URL from OpenWeatherMap.
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
 
// MARK: Clouds
 
struct Clouds: Codable {
    let all: Int
}
 
// MARK: Wind
 
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
 
// MARK: Precipitation (rain / snow)
struct Precipitation: Codable {
    let threeHour: Double?
 
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}
 
// MARK: Sys
struct Sys: Codable {
    /// Part of day: "d" for day, "n" for night.
    let pod: String
}

// MARK:  City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
 
// MARK:  Coordinate
struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}

// MARK: - Wallpaper -
struct WallpaperListResponse: Codable {
    var total: Int
    var page: Int
    var limit: Int
    var totalPages: Int//totalPages
    var data: [Wallpaper]
}
 
// MARK: Photo
struct Wallpaper: Codable, Identifiable {
    let src: PhotoSources
    let id: String
    let pexelsId: Int
    let width: Int
    let height: Int
    let url: String
    let alt: String
    let photographer: String
    let photographerId: Int
    let photographerUrl: String
    let avgColor: String
    let liked: Bool
    let category: String
    let createdAt: String
    let updatedAt: String
    let v: Int
 
    enum CodingKeys: String, CodingKey {
        case src
        case id = "_id"
        case pexelsId
        case width
        case height
        case url
        case alt
        case photographer
        case photographerId
        case photographerUrl
        case avgColor
        case liked
        case category
        case createdAt
        case updatedAt
        case v = "__v"
    }
}
 
// MARK: PhotoSources
 
struct PhotoSources: Codable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}



struct AppConfig: Codable, Identifiable {
    let id: String
    let name: String
    let packageName: String
    let appLink: String
    let consoleName: String
    let videoUrl: String
    let developerAccount: String
    let developedBy: String
    let status: String
    let version: String
    let logo: String
    let fbBannerId: String
    let fbNativeId: String
    let fbNativeBannerId: String
    let fbInterstialId: String
    let fbAdmobAlter: String
    let bannerId: String
    let nativeId: String
    let interstialId: String
    let appopenId: String
    let rewardId: String
    let secBannerId: String
    let secNativeId: String
    let secInterstialId: String
    let secAppopenId: String
    let addButtonColor: String
    let afterClick: String
    let afterClickNative: String
    let customNative: String
    let customBanner: String
    let customInterstial: String
    let customAppOpen: String
    let exitNative: String
    let removePakageName: String
    let jsonUrl: String
    let appType: String
    let isFavorite: Bool
    let isDeleted: Bool
    let createdBy: UserRef
    let createdAt: String
    let updatedAt: String
    let v: Int
    let extraFields: [String: String]
    let updatedBy: UserRef
 
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case packageName
        case appLink
        case consoleName
        case videoUrl
        case developerAccount
        case developedBy
        case status
        case version
        case logo
        case fbBannerId
        case fbNativeId
        case fbNativeBannerId
        case fbInterstialId
        case fbAdmobAlter
        case bannerId
        case nativeId
        case interstialId
        case appopenId
        case rewardId
        case secBannerId
        case secNativeId
        case secInterstialId
        case secAppopenId
        case addButtonColor
        case afterClick
        case afterClickNative
        case customNative
        case customBanner
        case customInterstial
        case customAppOpen
        case exitNative
        case removePakageName
        case jsonUrl
        case appType
        case isFavorite
        case isDeleted
        case createdBy
        case createdAt
        case updatedAt
        case v = "__v"
        case extraFields
        case updatedBy
    }
}
 
// MARK: - UserRef
 
struct UserRef: Codable {
    let id: String
    let name: String
 
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}
