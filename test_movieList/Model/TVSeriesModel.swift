//
//  TVSeriesModel.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import Foundation

struct TVSeries: Codable{
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
//    let originalLanguage: OriginalLanguage?
    let originalLanguage, originalName, overview: String?
    let popularity: Double
    let posterPath, firstAirDate, name: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct TVSeriesListResponse: Codable {
    let results: [TVSeries]
    let page: Int
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

enum OriginalLanguage: String, Codable {
    case de = "de"
    case en = "en"
    case fr = "fr"
    case ja = "ja"
    case ko = "ko"
}
