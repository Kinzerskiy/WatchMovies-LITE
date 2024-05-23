//
//  APIManager.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
    
    //MARK: Movies
    
    func fetchNowPlayingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/now_playing", page: page) { (result) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/popular", page: page) { (result) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTopRatedMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/top_rated", page: page) { (result) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUpcomingMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchMovies(with: "https://api.themoviedb.org/3/movie/upcoming", page: page) { (result) in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchMovies(with urlString: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        fetchData(urlString: urlString, page: page) { (result: Result<MovieListResponse, Error>) in
            switch result {
            case .success(let response):
                let movies = response.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)"
        fetchData(urlString: urlString) { (result: Result<MovieDetails, Error>) in
            completion(result)
        }
    }
    
    func fetchSimilarMovies(movieId: Int, completion: @escaping (Result<SimilarMoviesResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/similar"
        fetchData(urlString: urlString) { (result: Result<SimilarMoviesResponse, Error>) in
            completion(result)
        }
    }
    
    func fetchSearchMovies(page: Int, primaryReleaseYear: String? = nil, genre: String? = nil, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/movie"
        fetchData(urlString: urlString, primaryReleaseYear: primaryReleaseYear, genre: genre, page: page) { (result: Result<SearchMovieResponse, Error>) in
            switch result {
            case .success(let response):
                let movies = response.results
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchMovieVideos(movieId: Int, completion: @escaping (Result<MovieVideosResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos"
        fetchData(urlString: urlString) { (result: Result<MovieVideosResponse, Error>) in
            completion(result)
        }
    }
    
    func fetchMovieCredits(movieId: Int, completion: @escaping (Result<MovieCreditsResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits"
        fetchData(urlString: urlString) { (result: Result<MovieCreditsResponse, Error>) in
            completion(result)
        }
    }
    
    //MARK: TVSeries
    
    func fetchAiringTodaySeries(page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/airing_today", page: page) { (result) in
            switch result {
            case .success(let tvSeries):
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOnTheAirSeries(page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/on_the_air", page: page) { (result) in
            switch result {
            case .success(let tvSeries):
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPopularSeries(page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/popular", page: page) { (result) in
            switch result {
            case .success(let tvSeries):
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTopRatedSeries(page: Int, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        fetchTVSeries(with: "https://api.themoviedb.org/3/tv/top_rated", page: page) { (result) in
            switch result {
            case .success(let tvSeries):
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchTVSeries(with urlString: String, page: Int, completion: @escaping (Result< [TVSeries], Error>) -> Void) {
        fetchData(urlString: urlString, page: page) { (result: Result<TVSeriesListResponse, Error>) in
            switch result {
            case .success(let response):
                let tvSeries = response.results
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchTVSeriesDetails(seriesId: Int, completion: @escaping (Result<TVSeriesDetails, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/\(seriesId)"
        fetchData(urlString: urlString) { (result: Result<TVSeriesDetails, Error>) in
            completion(result)
        }
    }
    
    func fetchSimilarTVSeries(seriesId: Int, completion: @escaping (Result<SimilarTVSeriesResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/\(seriesId)/similar"
        fetchData(urlString: urlString) { (result: Result<SimilarTVSeriesResponse, Error>) in
            completion(result)
        }
    }
    
    func fetchSearchTVSeries(page: Int, firstAirDateYear: String? = nil, genre: String? = nil, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/discover/tv"
        fetchData(urlString: urlString, firstAirDateYear: firstAirDateYear, genre: genre, page: page) {
            (result: Result<SearchTVResponse, Error>) in
            switch result {
            case .success(let response):
                let tvSeries = response.results
                completion(.success(tvSeries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTVVideos(tvSeriesId: Int, completion: @escaping (Result<TVVideosResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(tvSeriesId)/videos"
        fetchData(urlString: urlString) { (result: Result<TVVideosResponse, Error>) in
            completion(result)
        }
    }
    
    func fetchTVSeriesCredits(tvSeriesId: Int, completion: @escaping (Result<TVShowCreditsResponse, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/tv/\(tvSeriesId)/credits"
        fetchData(urlString: urlString) { (result: Result<TVShowCreditsResponse, Error>) in
            completion(result)
        }
    }
    
    func fetchTVSeriesNextEpisodeDate(seriesId: Int, completion: @escaping (String?, Error?) -> Void) {
        fetchTVSeriesDetails(seriesId: seriesId) { result in
            switch result {
            case .success(let tvSeriesDetails):
                if let nextEpisodeDate = tvSeriesDetails.nextEpisodeToAir?.airDate {
                    completion(nextEpisodeDate, nil)
                } else {
                    completion(nil, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    //MARK: Person
    
    func fetchPersonDetails(personId: Int, completion: @escaping (Result<Person, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/person/\(personId)"
        fetchData(urlString: urlString) { (result: Result<Person, Error>) in
            completion(result)
        }
    }
    
    func fetchPersonMoviePersonCredits(personId: Int, completion: @escaping (Result<MovieCastRequest, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/person/\(personId)/movie_credits"
        fetchData(urlString: urlString) { (result: Result<MovieCastRequest, Error>) in
            completion(result)
        }
    }
    
    func fetchPersonTVPersonCredits(personId: Int, completion: @escaping (Result<TVSeriesCastRequest, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/person/\(personId)/tv_credits"
        fetchData(urlString: urlString) { (result: Result<TVSeriesCastRequest, Error>) in
            completion(result)
        }
    }
    
    //MARK: Common
    
    func fetchData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        fetchData(urlString: urlString, page: nil, completion: completion)
    }
    
    func fetchData<T: Codable>(urlString: String, primaryReleaseYear: String? = nil,  firstAirDateYear: String? = nil, genre: String? = nil, page: Int? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        if var urlComponents = URLComponents(string: urlString) {
            var queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
            ]
            if let primaryReleaseYear = primaryReleaseYear {
                queryItems.append(URLQueryItem(name: "primary_release_year", value: primaryReleaseYear))
            }
            if let firstAirDateYear = firstAirDateYear {
                queryItems.append(URLQueryItem(name: "first_air_date_year", value: firstAirDateYear))
            }
            if let genre = genre {
                queryItems.append(URLQueryItem(name: "with_genres", value: genre))
            }
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: String(page)))
            }
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                let error = NSError(domain: "APIManagerErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(.failure(error))
                return
            }
            
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyY2NjOWZjYjNlODg2ZmNiNWY4MDAxNTQxODczNTA5NSIsInN1YiI6IjY1Yjc0MTJiYTBiNjkwMDE3YmNlZjhmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Hhl93oP6hoKiYuXMis5VT-MVRfv1KZXhJjSncyCkhpw", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    DispatchQueue.main.async {
                        completion(.failure(error ?? NSError(domain: "APIManagerErrorDomain", code: 0, userInfo: nil)))
                    }
                    return
                }
                // Добавляем отладочное сообщение, чтобы посмотреть необработанные данные
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
