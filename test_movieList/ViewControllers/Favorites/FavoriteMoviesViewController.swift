//
//  FavoriteMoviesViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import CoreData

class FavoriteMoviesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
//    var favoriteMovies: [Movie] = []
    
    let navigationView = NavigationHeaderView.loadView()
    var router: FavoritesRouting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTableView()
//        fetchFavoriteMovies()
        makeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchFavoriteMovies()
    }
    
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.titleImage.image = UIImage(named: "Favorites")
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
//    func setupTableView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
//    }
    
//    func fetchFavoriteMovies() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        do {
//            favoriteMovies = try context.fetch(Movie.fetchRequest())
//            tableView.reloadData()
//        } catch {
//            print("Error fetching favorite movies: \(error)")
//        }
//    }
    
//    func handleFavoriteAction(for indexPath: IndexPath) {
//        let selectedMovie = favoriteMovies[indexPath.row]
////        selectedMovie.isFavorite.toggle()
//        saveChanges()
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
    
    
//    func saveChanges() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error saving changes: \(error)")
//        }
//    }
//    
//    func deleteMovieFromCoreData(_ movie: Movie) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        do {
//            context.delete(movie)
//            try context.save()
//        } catch {
//            print("Error deleting movie from Core Data: \(error)")
//        }
//    }
}


//extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return favoriteMovies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
//        
//        let movie = favoriteMovies[indexPath.row]
//        cell.fill(with: movie)
//        
//        cell.favoriteActionHandler = { [weak self] in
//            self?.handleFavoriteAction(for: indexPath)
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedMovie = favoriteMovies[indexPath.item]
//        router?.showFavoritesMoviesDetailForm(with: selectedMovie, viewController: self, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let movieToDelete = favoriteMovies[indexPath.row]
//            deleteMovieFromCoreData(movieToDelete)
//            favoriteMovies.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
//}
//
extension FavoriteMoviesViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() { }
}
