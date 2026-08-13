//
//  WebServicesUrls.swift
//  Mems
//
//  Created by iMac on 03/07/24.
//

import Foundation

var proxiUrl = "https://api-livevideocall.7seasol.in/proxy?url="
let serverUrl = proxiUrl + "https://api.themoviedb.org/3/"

//  MARK: - Home -
let topRatedMovieUrl = serverUrl + "movie/top_rated"
let celebrityUrl = serverUrl + "person/popular&page="
let upcommingMovieUrl = serverUrl + "movie/upcoming&page="
let onTheAirUrl = serverUrl + "tv/on_the_air&page="
let celebeityDetailUrl = serverUrl + "person/"
let celebrityMovieUrl = "movie_credits"
let celebritySeriesUrl = "tv_credits"
let searchUrl = serverUrl + "search/movie?query="
let searchSeriesUrl = serverUrl + "search/tv?query="

// MARK: - Deiscover -
let newReleaseUrl = serverUrl + "/movie/now_playing&page="
let populerUrl = serverUrl + "movie/popular&page="
let topRatedUrl = serverUrl + "movie/top_rated&page="
let airingTodayUrl = serverUrl + "tv/airing_today&page="
let topRatedSeriesUrl = serverUrl + "tv/top_rated&page="
let populerSeriesUrl = serverUrl + "tv/popular&page="

// MARK: - Movie Detail -
let movieDetailUrl = serverUrl + "movie/"
let setiesDetailUrl = serverUrl + "tv/"

// MARK: - Translate -
let translateAPI = "https://translate.googleapis.com/translate_a/single?"

// MARK: - Wallpaper -
let wallpapaerUrl = "https://api-pexels.7seasol.in/api/images/by-category?category=trending&page="

// MARK: - General info -
#if DEBUG
//Testing
let generalInfoUrl : String = "https://7seasol-application.s3.amazonaws.com/admin_prod/pbz-grfgvat-arj.json"
#else
//Prod
let generalInfoUrl : String = ""
#endif
