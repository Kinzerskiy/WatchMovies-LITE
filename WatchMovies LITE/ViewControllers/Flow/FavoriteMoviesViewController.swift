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
    var favorites: [Favorites] = []
    
    let navigationView = NavigationHeaderView.loadView()
    var router: FavoritesRouting?
    
    let emptyLabel: UILabel = {
          let label = UILabel()
          label.text = "Nothing here yet"
          label.textAlignment = .center
          label.textColor = .gray
          label.font = UIFont.lotaBold(ofSize: 25)
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupEmptyLabel()
        fetchFavoriteMedia()
        makeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMedia()
    }
    
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleLabel.text = "FAVORITES"
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    }
    
    func updateEmptyLabelVisibility() {
          emptyLabel.isHidden = !favorites.isEmpty
      }
    
    func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyLabel.isHidden = true
    }
      
    
    func fetchFavoriteMedia() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               return
           }
           let context = appDelegate.persistentContainer.viewContext
           
           do {
               favorites = try context.fetch(Favorites.fetchRequest())
               tableView.reloadData()
               updateEmptyLabelVisibility()
           } catch {
               print("Error fetching favorite movies: \(error)")
           }
       }
    
    func handleFavoriteAction(for indexPath: IndexPath) {
        let selectedMedia = favorites[indexPath.row]
        deleteFavoriteFromCoreData(selectedMedia) { [weak self] success in
            if success {
                self?.fetchFavoriteMedia()
            }
        }
    }

    func deleteFavoriteFromCoreData(_ favorite: Favorites, completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        context.perform {
            do {
                context.delete(favorite)
                try context.save()
                completion(true)
            } catch {
                print("Error deleting movie from Core Data: \(error)")
                completion(false)
            }
        }
    }


    
    
    func saveChanges() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    func deleteFavoriteFromCoreData(_ favorite: Favorites) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(favorite)
            try context.save()
        } catch {
            print("Error deleting movie from Core Data: \(error)")
        }
    }
}


extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        
        let favorite = favorites[indexPath.row]
        cell.fill(with: favorite)
        
        cell.favoriteActionHandler = { [weak self] in
            self?.handleFavoriteAction(for: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let id = favorite.mediaId
        router?.showDetailForm(with: Int(id), isMovie: favorite.isMovie, viewController: self, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteToDelete = favorites[indexPath.row]
            deleteFavoriteFromCoreData(favoriteToDelete)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FavoriteMoviesViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet()
    }
    
    func leftButtonTapped() { }
}
