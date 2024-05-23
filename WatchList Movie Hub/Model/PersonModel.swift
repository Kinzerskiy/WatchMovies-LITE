//
//  PersonModel.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import Foundation

struct Person: Codable {
    let adult: Bool
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday: String?
    let deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int
    let imdbId: String?
    let knownForDepartment: String?
    let name: String
    let placeOfBirth: String?
    let popularity: Double?
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

// MARK: - MovieCastRequest
struct MovieCastRequest: Codable {
    let crew, cast: [MovieCastMember]
    let id: Int
}

// MARK: - MovieCastMember

struct MovieCastMember: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    let department: String?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditId = "credit_id"
        case order, department, job
    }
}

//MARK: TVSeriesCastRequest

struct TVSeriesCastRequest: Codable {
    let cast, crew: [TVSeriesMember]
    let id: Int
}

struct TVSeriesMember: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originCountry: [OriginCountry]?
    let originalLanguage: String?
    let originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let firstAirDate, name: String?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?
    let creditID: String
    let episodeCount: Int?
    let department, job: String?
    
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
        case character
        case creditID = "credit_id"
        case episodeCount = "episode_count"
        case department, job
    }
}

enum OriginCountry: String, Codable {
    case au = "AU"
    case br = "BR"
    case de = "DE"
    case gb = "GB"
    case us = "US"
}
