//
//  APIManager.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation

class APIManager {
    let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
  
    //MARK: Movies
    
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
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (MovieDetails?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)"
        fetchData(urlString: urlString, completion: completion)
    }
   
    func fetchSimilarMovies(movieId: Int, completion: @escaping (SimilarMoviesResponse?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar"
        fetchData(urlString: urlString) { (response: SimilarMoviesResponse?, error) in
            if let error = error {
                print("Error fetching similar movies: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            if let response = response {
                print("Fetched similar movies: \(response.results)")
                completion(response, nil)
            }
        }
    }
    
    func fetchSearchMovies(page: Int, includeAdult: Bool? = nil, primaryReleaseYear: String? = nil, ganre: String? = nil, completion: @escaping ([Movie], Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/movie"
        fetchData(urlString: urlString, includeAdult: includeAdult, primaryReleaseYear: primaryReleaseYear, ganre: ganre, page: page) { (response: SearchMovieResponse?, error) in
            guard let response = response else {
                completion([], error)
                return
            }
            
            let movies = response.results
            completion(movies, nil)
        }
    }

    //MARK: TVSeries
    
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
    
    func fetchTVSeriesDetails(seriesId: Int, completion: @escaping (TVSeriesDetails?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/\(seriesId)"
        fetchData(urlString: urlString, completion: completion)
    }
    
    func fetchSimilarTVSeries(seriesId: Int, completion: @escaping (SimilarTVSeriesResponse?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/\(seriesId)/similar"
        fetchData(urlString: urlString) { (response: SimilarTVSeriesResponse?, error) in
            if let error = error {
                print("Error fetching similar movies: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            if let response = response {
                print("Fetched similar movies: \(response.results)")
                completion(response, nil)
            }
        }
    }
    
    func fetchSearchTVSeries(page: Int, includeAdult: Bool? = nil, firstAirDateYear: String? = nil, genre: String? = nil, completion: @escaping ([TVSeries], Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/tv"
        fetchData(urlString: urlString, includeAdult: includeAdult, firstAirDateYear: firstAirDateYear, ganre: genre, page: page) { (response: SearchTVResponse?, error) in
            guard let response = response else {
                completion([], error)
                return
            }
            let tvSeries = response.results
            completion(tvSeries, nil)
        }
    }
    
    //MARK: Common
    
    func fetchData<T: Codable>(urlString: String, completion: @escaping (T?, Error?) -> Void) {
        fetchData(urlString: urlString, page: nil, completion: completion)
    }
    
    func fetchData<T: Codable>(urlString: String, includeAdult: Bool? = nil, primaryReleaseYear: String? = nil,  firstAirDateYear: String? = nil, ganre: String? = nil, page: Int? = nil, completion: @escaping (T?, Error?) -> Void) {
        if var urlComponents = URLComponents(string: urlString) {
            var queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
            ]
            if let includeAdult = includeAdult {
                queryItems.append(URLQueryItem(name: "include_adult", value: String(includeAdult)))
            }
            if let primaryReleaseYear = primaryReleaseYear {
                queryItems.append(URLQueryItem(name: "primary_release_year", value: primaryReleaseYear))
            }
            if let firstAirDateYear = firstAirDateYear {
                queryItems.append(URLQueryItem(name: "first_air_date_year", value: primaryReleaseYear))
            }
            if let ganre = ganre {
                queryItems.append(URLQueryItem(name: "with_genres", value: ganre))
            }
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: String(page)))
            }
            urlComponents.queryItems = queryItems
            
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
