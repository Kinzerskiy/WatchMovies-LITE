//
//  MovieModel.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import Foundation

struct Movie: Codable {
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieListResponse: Codable {
    let dates: Dates?
    let page: Int
    let results: [Movie]
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
}
