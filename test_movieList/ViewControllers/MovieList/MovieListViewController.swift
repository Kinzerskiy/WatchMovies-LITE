//
//  MovieListViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let apiManager = APIManager()
    let navigationView = NavigationHeaderView.loadView()
    var movies: [MovieListResponse.MovieList] = []
    
    var router: ListRouting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBar()
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.isUserInteractionEnabled = true
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func prepareUI() {
        apiManager.fetchData { [weak self] movies, error in
            if let movies = movies {
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func handleLongPressOnCell(with movie: MovieListResponse.MovieList) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", movie.title)
        
        do {
            let existingMovies = try context.fetch(fetchRequest)
            if let existingMovie = existingMovies.first {
                showAlertDialog(title: "Movie Already Exists", message: "\(existingMovie.title ?? "") is already in your collection.")
            } else {
                let newMovie = Movie(context: context)
                newMovie.title = movie.title
                newMovie.overview = movie.overview
                newMovie.posterImage = movie.posterPath
                newMovie.releaseDate = movie.releaseDate
                try context.save()
                showAlertDialog(title: "Movie Saved", message: "\(newMovie.title ?? "") has been added to your collection.")
            }
        } catch {
            showAlertDialog(title: "Error", message: "Error saving movie to Core Data.")
        }
    }
    
    private func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movieIndex = indexPath.item
        if movieIndex < movies.count {
            let movie = movies[movieIndex]
            cell.fill(with: movie)
            cell.longPressHandler = { [weak self] in
                self?.handleLongPressOnCell(with: movie)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        router?.showMoviesDetailForm(with: selectedMovie, viewController: self, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MovieListViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() { }
}
