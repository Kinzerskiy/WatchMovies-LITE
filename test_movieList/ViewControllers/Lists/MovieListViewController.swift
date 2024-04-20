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
    @IBOutlet weak var segmentBarView: UIView!
    
    var router: MovieListRouting?
    let apiManager = APIManager()
    let navigationView = NavigationHeaderView.loadView()
    let filterView = FilterView.loadView()
    
    var movies: [Movie] = []
    private var currentPage = [0, 0, 0, 0]
    private var currentSegmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        makeNavigationBar()
        prepareCollectionView()
        prepareSegmenBar()
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
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
    
    
    func prepareSegmenBar() {
        let segmentTitles = ["Now playing", "Popular", "Top", "Upcoming"]
        filterView.setSegmentTitles(titles: segmentTitles)
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
    }
    
    func prepareUI() {
        fetchMovies(for: currentSegmentIndex, page: 1) { movies, error, segmentIndex in
               self.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
           }
       
    }
    
    //вынести
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
//            let movie = movies[movieIndex]
            let movie = movies[movieIndex]
            cell.fill(withData: movie)
//            cell.longPressHandler = { [weak self] in
//                self?.handleLongPressOnCell(with: movie)
//            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        router?.showDetailForm(with: selectedMovie.id, viewController: self, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreMoviesIfNeeded(for: currentSegmentIndex)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

extension MovieListViewController: NavigationHeaderViewDelegate {
    
    func leftButtonTapped() { }
}

extension MovieListViewController: FilterViewDelegate {
    
    func segment1() {
        currentSegmentIndex = 0
        fetchMovies(for: currentSegmentIndex, page: 1) { movies, error, segmentIndex in
            self.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment2() {
        currentSegmentIndex = 1
        fetchMovies(for: currentSegmentIndex, page: 1) { movies, error, segmentIndex in
            self.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment3() {
        currentSegmentIndex = 2
        fetchMovies(for: currentSegmentIndex, page: 1) { movies, error, segmentIndex in
            self.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment4() {
        currentSegmentIndex = 3
        fetchMovies(for: currentSegmentIndex, page: 1) { movies, error, segmentIndex in
            self.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func searchTapped() {
        
    }
    
    
    private func fetchMovies(for segmentIndex: Int, page: Int, completion: @escaping ([Movie]?, Error?, Int) -> Void) {
        switch segmentIndex {
        case 0:
            apiManager.fetchNowPlayingMovies(page: page) { movies, error in
                completion(movies, error, segmentIndex)
            }
        case 1:
            apiManager.fetchPopularMovies(page: page) { movies, error in
                completion(movies, error, segmentIndex)
            }
        case 2:
            apiManager.fetchTopRatedMovies(page: page) { movies, error in
                completion(movies, error, segmentIndex)
            }
        case 3:
            apiManager.fetchUpcomingMovies(page: page) { movies, error in
                completion(movies, error, segmentIndex)
            }
        default:
            break
        }
    }

    private func handleFetchResponse(movies: [Movie]?, error: Error?, segmentIndex: Int) {
        guard let movies = movies else {
            showAlertDialog(title: "Error", message: error?.localizedDescription ?? "Unknown error")
            return
        }

        self.movies = movies

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

       
    private func loadMoreMoviesIfNeeded(for segmentIndex: Int) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let lastVisibleIndexPath = visibleIndexPaths.last ?? IndexPath(item: 0, section: 0)

        if lastVisibleIndexPath.item >= movies.count - 4 {
            currentPage[segmentIndex] += 1
            fetchMovies(for: segmentIndex, page: currentPage[segmentIndex]) { movies, error, segmentIndex in
                guard let movies = movies else { return }
                self.movies += movies
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}



//    private func handleLongPressOnCell(with tvShow: /*MovieListResponse.MovieList*/TVShowListResponse.TVShow) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "title == %@", tvShow.name)
//
//        do {
//            let existingMovies = try context.fetch(fetchRequest)
//            if let existingMovie = existingMovies.first {
//                showAlertDialog(title: "Movie Already Exists", message: "\(existingMovie.title ?? "") is already in your collection.")
//            } else {
//                let newMovie = Movie(context: context)
//                newMovie.title = tvShow.name
//                newMovie.overview = tvShow.overview
//                newMovie.posterImage = tvShow.posterPath
//                newMovie.releaseDate = tvShow.firstAirDate
//                try context.save()
//                showAlertDialog(title: "Movie Saved", message: "\(newMovie.title ?? "") has been added to your collection.")
//            }
//        } catch {
//            showAlertDialog(title: "Error", message: "Error saving movie to Core Data.")
//        }
//    }
    
