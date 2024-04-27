//
//  MovieModel.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import Foundation

// MARK: - MovieList

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

// MARK: - MovieDetails

struct MovieDetails: Codable, MediaDetails {
    var firstAirDate: String?
    var genres: [Genre]
    var releaseDate: String?
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let homepage: String
    let id: Int
    let imdbId: String
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
   
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
}

 struct Genre: Codable {
    let id: Int
    let name: String
}

 struct ProductionCompany: Codable {
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

 struct ProductionCountry: Codable {
    let iso31661: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

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

//MARK: Similar

struct SimilarMoviesResponse: Codable {
    let page: Int
    let results: [SimilarMovie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct SimilarMovie: Codable, MediaDetails {
    var firstAirDate: String?
    
    var genres: [Genre]
    
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let genreIds: [Int]?
    let originalLanguage: String?
    let originalTitle: String?
    let popularity: Double?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        let genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
        genres = genreIds.map { Genre(id: $0, name: "") }
    }
}

//MARK: Search

struct SearchMovieResponse: Codable {
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

//MARK: GenreID

enum MovieGenreID: String, CaseIterable {
    case action = "28"
    case adventure = "12"
    case animation = "16"
    case comedy = "35"
    case crime = "80"
    case documentary = "99"
    case drama = "18"
    case family = "10751"
    case fantasy = "14"
    case history = "36"
    case horror = "27"
    case music = "10402"
    case mystery = "9648"
    case romance = "10749"
    case scienceFiction = "878"
    case tvMovie = "10770"
    case thriller = "53"
    case war = "10752"
    case western = "37"
    
    static var allCases: [MovieGenreID] {
        return [.action, .adventure, .animation, .comedy, .crime, .documentary, .drama, .family, .fantasy, .history, .horror, .music, .mystery, .romance, .scienceFiction, .tvMovie, .thriller, .war, .western]
    }
}
