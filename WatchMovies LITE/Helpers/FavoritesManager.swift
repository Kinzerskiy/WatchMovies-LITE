//
//  FavoritesManager.swift
//  WatchMovies LITE
//
//  Created by User on 02.05.2024.
//

import Foundation
import CoreData

enum WatchlistType: String {
    case toWatch = "isToWatch"
    case hasWatched = "hasWatched"
}

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private init() {}
    
    func saveToWatchlist(data: Any, watchlistType: WatchlistType) {
        let context = CoreDataManager.shared.context
        let favorite = Favorites(context: context)
        
        if let movieDetails = data as? MovieDetails {
            favorite.id = Int64(movieDetails.id)
            favorite.isMovie = true
            switch watchlistType {
            case .toWatch:
                favorite.isWatchingType = true
            case .hasWatched:
                favorite.isWatchingType = false
            }
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            favorite.id = Int64(tvSeriesDetails.id)
            favorite.isMovie = false
            switch watchlistType {
            case .toWatch:
                favorite.isWatchingType = true
            case .hasWatched:
                favorite.isWatchingType = false
            }
        } else if let movie = data as? Movie {
            favorite.id = Int64(movie.id)
            favorite.isMovie = true
            switch watchlistType {
            case .toWatch:
                favorite.isWatchingType = true
            case .hasWatched:
                favorite.isWatchingType = false
            }
        } else if let  tvSeries = data as? TVSeries {
            favorite.id = Int64(tvSeries.id)
            favorite.isMovie = false
            switch watchlistType {
            case .toWatch:
                favorite.isWatchingType = true
            case .hasWatched:
                favorite.isWatchingType = false
            }
        }
        CoreDataManager.shared.saveContext()
    }
    
    func isMediaFavorite(media: MediaId) -> Bool {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", media.id)
        request.fetchLimit = 1
        
        do {
            let favorites = try context.fetch(request)
            return !favorites.isEmpty
        } catch {
            print("Error fetching favorite media: \(error)")
            return false
        }
    }
    
    func fetchFavoriteMedia(for data: MediaId) -> Favorites? {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", data.id)
        request.fetchLimit = 1
        
        
        do {
            let favorites = try context.fetch(request)
            return favorites.first
        } catch {
            print("Error fetching favorite media: \(error)")
            return nil
        }
    }
    
    func saveToHasWatched(data: Any) {
        saveToWatchlist(data: data, watchlistType: .hasWatched)
    }
    
    func isMediaInWatchlist(media: MediaId, watchlistType: WatchlistType) -> Bool {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        var predicates: [NSPredicate] = [
            NSPredicate(format: "id == %ld", media.id),
            NSPredicate(format: "\(watchlistType.rawValue) == true")
        ]

        if media is Movie {
            predicates.append(NSPredicate(format: "isMovie == true"))
        } else if media is TVSeries {
            predicates.append(NSPredicate(format: "isMovie == false"))
        } else if media is MovieDetails {
            predicates.append(NSPredicate(format: "isMovie == true"))
        } else if media is TVSeriesDetails {
            predicates.append(NSPredicate(format: "isMovie == false"))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.fetchLimit = 1
        
        do {
            let favorites = try context.fetch(request)
            return !favorites.isEmpty
        } catch {
            print("Error fetching favorite media: \(error)")
            return false
        }
    }


    
    func deleteFavorite(favorite: Favorites) {
        CoreDataManager.shared.context.delete(favorite)
        CoreDataManager.shared.saveContext()
    }
    
    func deleteAllFavorites(completion: @escaping () -> Void) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            for favorite in favorites {
                context.delete(favorite)
            }
            CoreDataManager.shared.saveContext()
            completion()
        } catch {
            print("Error deleting favorites: \(error)")
        }
    }
    
    func fetchFavoritesForMovies() -> [Favorites]? {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "isMovie == true")
        
        do {
            let favoriteMovies = try context.fetch(request)
            let filteredMovies = favoriteMovies.filter { $0.isWatchingType == false }
            return filteredMovies
        } catch {
            print("Error fetching favorite movies: \(error)")
            return nil
        }
    }

    func fetchFavoritesForTVSeries() -> [Favorites]? {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "isMovie == false")
        
        do {
            let favoriteTVSeries = try context.fetch(request)
            let filteredTVSeries = favoriteTVSeries.filter { $0.isWatchingType == false }
            return filteredTVSeries
        } catch {
            print("Error fetching favorite TV series: \(error)")
            return nil
        }
    }

}
