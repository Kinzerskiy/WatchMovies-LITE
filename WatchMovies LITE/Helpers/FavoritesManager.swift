//
//  FavoritesManager.swift
//  WatchMovies LITE
//
//  Created by User on 02.05.2024.
//

import Foundation
import CoreData

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private init() {}
    
    func saveToFavorites(data: MediaDetails) {
        let context = CoreDataManager.shared.context
        let favorite = Favorites(context: context)
        
        if let movieDetails = data as? MovieDetails {
            favorite.posterPath = movieDetails.posterPath
            favorite.mediaId = Int64(movieDetails.id)
            favorite.title = movieDetails.title
            favorite.isMovie = true
            favorite.isFavorite = true
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            favorite.posterPath = tvSeriesDetails.posterPath
            favorite.mediaId = Int64(tvSeriesDetails.id)
            favorite.title = tvSeriesDetails.name
            favorite.isMovie = false
            favorite.isFavorite = true
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    func fetchFavoriteMedia(for data: MediaDetails) -> Favorites? {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "mediaId == %ld", data.id)
        request.fetchLimit = 1
        
        do {
            let favorites = try context.fetch(request)
            return favorites.first
        } catch {
            print("Error fetching favorite media: \(error)")
            return nil
        }
    }
    
    func deleteFavorite(favorite: Favorites) {
        CoreDataManager.shared.context.delete(favorite)
        CoreDataManager.shared.saveContext()
    }
}
