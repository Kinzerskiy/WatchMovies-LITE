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
    var favoritesByGenre: [String: [Favorites]] = [:]
    var genres: [String] = []
    
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
            emptyLabel.isHidden = !favoritesByGenre.isEmpty
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
//           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//               return
//           }
//           let context = appDelegate.persistentContainer.viewContext
//           
//           do {
//               let allFavorites = try context.fetch(Favorites.fetchRequest())
//               
//               for favorite in allFavorites {
//                   if let genre = favorite.genre {
//                       if favoritesByGenre[genre] == nil {
//                           genres.append(genre)
//                           favoritesByGenre[genre] = []
//                       }
//                       favoritesByGenre[genre]?.append(favorite)
//                   }
//               }
//               
//               genres.sort()
//               tableView.reloadData()
//               updateEmptyLabelVisibility()
//           } catch {
//               print("Error fetching favorite movies: \(error)")
//           }
       }
    
    func handleFavoriteAction(for indexPath: IndexPath) {
        let genre = genres[indexPath.section]
        if let favoritesInSection = favoritesByGenre[genre] {
            let selectedMedia = favoritesInSection[indexPath.row]
            deleteFavoriteFromCoreData(selectedMedia) { [weak self] success in
                if success {
                    self?.fetchFavoriteMedia()
                }
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
}


extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let genre = genres[section]
        return favoritesByGenre[genre]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell

        let genre = genres[indexPath.section]
               if let favorites = favoritesByGenre[genre] {
                   cell.favorites = favorites
               }
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//           return genres[section]
//       }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let favorite = favorites[indexPath.row]
//        let id = favorite.mediaId
//        router?.showDetailForm(with: Int(id), isMovie: favorite.isMovie, viewController: self, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let favoriteToDelete = favorites[indexPath.row]
//            deleteFavoriteFromCoreData(favoriteToDelete) { [weak self] success in
//                if success {
//                    self?.fetchFavoriteMedia()
//                }
//                
//            }
//            favorites.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
}

extension FavoriteMoviesViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet()
    }
    func leftButtonTapped() { }
}
