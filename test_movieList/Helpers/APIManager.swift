//
//  APIManager.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation


struct TVShowListResponse: Codable {
    let results: [TVShow]
    
    struct TVShow: Codable {
        let id: Int
        let name: String
        let overview: String
        let posterPath: String
        let firstAirDate: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case overview
            case posterPath = "poster_path"
            case firstAirDate = "first_air_date"
        }
    }
}

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

class APIManager {
    let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/now_playing", page: page, completion: completion)
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/popular", page: page, completion: completion)
    }
    
    func fetchTopRatedMovies(page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/top_rated", page: page, completion: completion)
    }
    
    func fetchUpcomingMovies(page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/upcoming", page: page, completion: completion)
    }
    
    private func fetchMovies(with urlString: String, page: Int, completion: @escaping ([Movie], Error?) -> Void) {
        fetchData(urlString: urlString, page: page) { (response: MovieListResponse?, error) in
            guard let response = response else {
                completion([], error)
                return
            }
            
            let movies = response.results
            completion(movies, nil)
        }
    }
    
    func fetchData<T: Codable>(urlString: String, page: Int, completion: @escaping (T?, Error?) -> Void) {
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "page", value: String(page))
            ]
            
            guard let url = urlComponents.url else {
                fatalError("Invalid URL")
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyY2NjOWZjYjNlODg2ZmNiNWY4MDAxNTQxODczNTA5NSIsInN1YiI6IjY1Yjc0MTJiYTBiNjkwMDE3YmNlZjhmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Hhl93oP6hoKiYuXMis5VT-MVRfv1KZXhJjSncyCkhpw", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil, error)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    completion(response, nil)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
