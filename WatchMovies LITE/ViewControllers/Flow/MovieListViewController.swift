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
    
    let navigationView = NavigationHeaderView.loadView()
    let filterView = FilterView.loadView()
    
    var movies: [Movie] = []
    private var currentPage = [0, 0, 0]
    private var currentSegmentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareSegmenBar()
        makeNavigationBar()
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleLabel.text = "MOVIES"
        navigationView.titleName.isHidden = true
        navigationView.actionButton.isHidden = true
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
        collectionView.backgroundColor = .white
    }
    
    
    func prepareSegmenBar() {
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
        let segmentTitles = ["NOW PLAYING", "UPCOMING", "TOP"]
        let font = UIFont.lotaBold(ofSize: 12)
        let color = UIColor.black
        filterView.setSegmentTitles(titles: segmentTitles, font: font, color: color)
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               filterView.topAnchor.constraint(equalTo: segmentBarView.topAnchor),
               filterView.leadingAnchor.constraint(equalTo: segmentBarView.leadingAnchor),
               filterView.bottomAnchor.constraint(equalTo: segmentBarView.bottomAnchor),
               filterView.trailingAnchor.constraint(equalTo: segmentBarView.trailingAnchor)
           ])
        filterView.setupView()
    }
    
    func prepareUI() {
        fetchMovies(for: currentSegmentIndex, page: 1) { [weak self]  movies, error, segmentIndex in
               self?.handleFetchResponse(movies: movies, error: error, segmentIndex: segmentIndex)
           }
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
            cell.fill(withData: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        router?.showDetailForm(with: selectedMovie.id, isMovie: true, viewController: self, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreMoviesIfNeeded(for: currentSegmentIndex)
    }
        
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
    func rightButtonTapped() {
        showRateAndSupportActionSheet {
            self.collectionView.reloadData()
        }
    }
    
    func leftButtonTapped() { }
    func actionButtonTapped() { }
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

    func segment4() { }
    
    
    private func fetchMovies(for segmentIndex: Int, page: Int, completion: @escaping ([Movie]?, Error?, Int) -> Void) {
        switch segmentIndex {
        case 0:
            APIManager.shared.fetchNowPlayingMovies(page: page) { [weak self] movies, error in
                completion(movies, error, segmentIndex)
                if let error = error {
                    self?.showAlertDialog(title: "Error", message: error.localizedDescription)
                }
            }
        case 1:
            APIManager.shared.fetchUpcomingMovies(page: page) { [weak self] movies, error in
                completion(movies, error, segmentIndex)
                if let error = error {
                    self?.showAlertDialog(title: "Error", message: error.localizedDescription)
                }
            }
        case 2:
            APIManager.shared.fetchTopRatedMovies(page: page) { [weak self] movies, error in
                completion(movies, error, segmentIndex)
                if let error = error {
                    self?.showAlertDialog(title: "Error", message: error.localizedDescription)
                }
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
