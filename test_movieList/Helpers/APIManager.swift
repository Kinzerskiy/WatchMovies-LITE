//
//  APIManager.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation

struct MovieListResponse: Codable {
    
    let results: [MovieList]
    
    struct MovieList: Codable {
        let title: String
        let overview: String
        let posterPath: String
        let releaseDate: String
        
        
        enum CodingKeys: String, CodingKey {
            case title
            case overview
            case posterPath = "poster_path"
            case releaseDate = "release_date"
        }
    }
}

class APIManager {
    
    let apiKey = "2ccc9fcb3e886fcb5f80015418735095"
    let urlString = "https://api.themoviedb.org/3/discover/movie"
    
    var movies: [MovieListResponse.MovieList]?
    
    func fetchData(completion: @escaping ([MovieListResponse.MovieList]?, Error?) -> Void) {
        if var urlComponents = URLComponents(string: urlString) {
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: apiKey)
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
                    let movieListResponse = try decoder.decode(MovieListResponse.self, from: data)
                    self.movies = movieListResponse.results
                    
                    completion(self.movies, nil)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
