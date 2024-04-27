//
//  TVSeriesModel.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import Foundation

protocol MediaDetails {
    var id: Int { get }
    var posterPath: String? { get }
    var genres: [Genre] { get }
    var voteAverage: Double { get }
    var releaseDate: String? { get }
    var firstAirDate: String? { get }
    var overview: String { get }
}

//MARK: - TVSeries

struct TVSeries: Codable{
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
//    let originalLanguage: OriginalLanguage?
    let originalName, overview: String
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
//        case originalLanguage = "original_language"
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

//MARK: - TVSeriesDetails

struct TVSeriesDetails: Codable, MediaDetails {
    var firstAirDate: String?
    
    var releaseDate: String?
    let adult: Bool
    let backdropPath: String?
    let createdBy: [Creator]
    let episodeRunTime: [Int]
    let genres: [Genre]
    let homepage: String
    let id: Int
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: String
    let lastEpisodeToAir: EpisodeDetails
    let name: String
    let nextEpisodeToAir: EpisodeDetails?
    let networks: [Network]
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let seasons: [Season]
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let type: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct Creator: Codable {
    let id: Int
    let name: String
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case gender
        case profilePath = "profile_path"
    }
}

struct EpisodeDetails: Codable {
    let id: Int
    let overview: String
    let name: String
    let voteAverage: Double
    let voteCount: Int
    let airDate: String
    let episodeNumber: Int
    let episodeType: String
    let productionCode: String?
    let runtime: Int?
    let seasonNumber: Int
    let showId: Int
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case name
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

struct Network: Codable {
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

struct Season: Codable {
    let airDate: String?
    let episodeCount: Int
    let id: Int
    let name: String
    let overview: String?
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

//MARK: Similar


struct SimilarTVSeriesResponse: Codable {
    let page: Int
    let results: [SimilarTVSeries]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SimilarTVSeries: Codable {
    var releaseDate: String?
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let firstAirDate, name: String
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


// MARK: - Search

struct SearchTVResponse: Codable {
    let page: Int
    let results: [TVSeries]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//MARK: GenreID

enum TVGenreID: String, CaseIterable {
    case actionAdventure = "10759"
    case animation = "16"
    case comedy = "35"
    case crime = "80"
    case documentary = "99"
    case drama = "18"
    case family = "10751"
    case kids = "10762"
    case mystery = "9648"
    case news = "10763"
    case reality = "10764"
    case sciFiFantasy = "10765"
    case soap = "10766"
    case talk = "10767"
    case warPolitics = "10768"
    case western = "37"
    
    static var allCases: [TVGenreID] {
        return [.actionAdventure, .animation, .comedy, .crime, .documentary, .drama, .family, .kids, .mystery, .news, .reality, .sciFiFantasy, .soap, .talk, .warPolitics, .western]
    }
}
