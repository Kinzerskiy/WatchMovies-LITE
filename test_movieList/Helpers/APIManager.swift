//
//  APIManager.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation



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
    
    func fetchAiringTodaySeries(page: Int, completion: @escaping ([TVSeries], Error?) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/airing_today", page: page, completion: completion)
    }
    
    func fetchOnTheAirSeries(page: Int, completion: @escaping ([TVSeries], Error?) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/on_the_air", page: page, completion: completion)
    }
    
    func fetchPopularSeries(page: Int, completion: @escaping ([TVSeries], Error?) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/popular", page: page, completion: completion)
    }
    
    func fetchTopRatedSeries(page: Int, completion: @escaping ([TVSeries], Error?) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/top_rated", page: page, completion: completion)
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
    
    private func fetchTVSeries(with urlString: String, page: Int, completion: @escaping ([TVSeries], Error?) -> Void) {
        fetchData(urlString: urlString, page: page) { (response: TVSeriesListResponse?, error) in
            guard let response = response else {
                completion([], error)
                return
            }
            
            let tvSeries = response.results
            completion(tvSeries, nil)
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
