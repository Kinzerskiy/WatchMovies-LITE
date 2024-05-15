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
    @IBOutlet weak var segmentBarView: UIView!
    
    let navigationView = NavigationHeaderView.loadView()
    let filterView = FilterView.loadView()
    var currentSegmentIndex: Int = 0
    
    var router: FavoritesRouting?
    
    var favoriteMoviesIDs: [Int] = []
    var favoriteTVSeriesIDs: [Int] = []
    
    var movieDetails: [MovieDetails] = []
    var tvSeriesDetails: [TVSeriesDetails] = []
    
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
        prepareSegmenBar()
        makeNavigationBar()
        fetchFavoriteMediaIDs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMediaIDs()
    }
    
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleLabel.text = "FAVORITES"
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareSegmenBar() {
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
        let segmentTitles = ["Movie", "TV"]
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
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
    }
    
    func updateEmptyLabelVisibility() {
        
    }
    
    func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyLabel.isHidden = true
    }
    
    func fetchFavoriteMediaIDs() {
        if let favoriteMovies = FavoritesManager.shared.fetchFavoritesForMovies() {
            favoriteMoviesIDs = favoriteMovies.map { Int($0.id) }
            for id in favoriteMoviesIDs {
                fetchMediaDetails(isMovie: true, mediaId: id) {
                    self.tableView.reloadData()
                }
            }
        }
        
        if let favoriteTVSeries = FavoritesManager.shared.fetchFavoritesForTVSeries() {
            favoriteTVSeriesIDs = favoriteTVSeries.map { Int($0.id) }
            for id in favoriteTVSeriesIDs {
                fetchMediaDetails(isMovie: false, mediaId: id) {
                    self.tableView.reloadData()
                }
            }
        }
        tableView.reloadData()
        updateEmptyLabelVisibility()
    }
    
    func fetchMediaDetails(isMovie: Bool, mediaId: Int, completion: @escaping () -> Void) {
        
        if isMovie {
            self.movieDetails.removeAll()
            APIManager.shared.fetchMovieDetails(movieId: mediaId) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                print(response)
                self.movieDetails.append(response)
                completion()
            }
        } else {
            self.tvSeriesDetails.removeAll()
            APIManager.shared.fetchTVSeriesDetails(seriesId: mediaId) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                print(response)
                self.tvSeriesDetails.append(response)
                completion()
            }
        }
    }
}


extension FavoriteMoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSegmentIndex == 0 {
            return Set(movieDetails.compactMap { $0.genres.map { $0.name } }).count
        } else if currentSegmentIndex == 1 {
            return Set(tvSeriesDetails.compactMap { $0.genres.map { $0.name } }).count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        cell.segmentIndex = currentSegmentIndex
        
        if currentSegmentIndex == 0 {
            cell.movieDetails = movieDetails
        } else if currentSegmentIndex == 1 {
            cell.tvSeriesDetails = tvSeriesDetails
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoriteMoviesViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet()
    }
    func leftButtonTapped() { }
}


extension FavoriteMoviesViewController: FilterViewDelegate {
    func segment1() {
        currentSegmentIndex = 0
        tableView.reloadData()
    }
    
    func segment2() {
        currentSegmentIndex = 1
        tableView.reloadData()
    }
    
    func segment3() { }
    
    func segment4() {  }
}


//        FavoritesManager.shared.deleteAllFavorites()


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
