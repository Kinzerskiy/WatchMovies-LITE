//
//  FavoriteMoviesViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
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
    
    var genreDetails: [GenreDetails] = []
    
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
        fetchFavoriteMediaIDs(forSection: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteMediaIDs(forSection: currentSegmentIndex)
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
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
    
    func updateEmptyLabelVisibility() {
        let isEmpty: Bool
        if currentSegmentIndex == 0 {
            isEmpty = favoriteMoviesIDs.isEmpty
        } else {
            isEmpty = favoriteTVSeriesIDs.isEmpty
        }
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyLabel.isHidden = true
    }
    
    func fetchFavoriteMediaIDs(forSection section: Int) {
        let group = DispatchGroup()

        if section == 0 {
            favoriteMoviesIDs.removeAll()
            movieDetails.removeAll()

            if let favoriteMovies = FavoritesManager.shared.fetchFavoritesForMovies() {
                favoriteMoviesIDs = favoriteMovies.map { Int($0.id) }
                for id in favoriteMoviesIDs {
                    group.enter()
                    fetchMediaDetails(isMovie: true, mediaId: id) {
                        group.leave()
                    }
                }
            }
        } else {
            favoriteTVSeriesIDs.removeAll()
            tvSeriesDetails.removeAll()

            if let favoriteTVSeries = FavoritesManager.shared.fetchFavoritesForTVSeries() {
                favoriteTVSeriesIDs = favoriteTVSeries.map { Int($0.id) }
                for id in favoriteTVSeriesIDs {
                    group.enter()
                    fetchMediaDetails(isMovie: false, mediaId: id) {
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            self.updateEmptyLabelVisibility()
            self.tableView.reloadData()
        }
    }
    func fetchMediaDetails(isMovie: Bool, mediaId: Int, completion: @escaping () -> Void) {
        
        if isMovie {
            APIManager.shared.fetchMovieDetails(movieId: mediaId) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                
                self.movieDetails.append(response)
                completion()
            }
        } else {
            APIManager.shared.fetchTVSeriesDetails(seriesId: mediaId) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                
                self.tvSeriesDetails.append(response)
                completion()
            }
        }
    }
    
    func groupByGenre() -> [GenreDetails] {
        var genreDetails: [GenreDetails] = []
        
        let details: [Any] = currentSegmentIndex == 0 ? movieDetails : tvSeriesDetails
        
        for detail in details {
            if let movieDetail = detail as? MovieDetails {
                if let firstGenre = movieDetail.genres.first {
                    let existsInAnotherGenre = genreDetails.contains { $0.movies.contains { $0.id == movieDetail.id } }
                    if !existsInAnotherGenre {
                        if let index = genreDetails.firstIndex(where: { $0.genre == firstGenre.name }) {
                            genreDetails[index].movies.append(movieDetail)
                        } else {
                            genreDetails.append(GenreDetails(genre: firstGenre.name, movies: [movieDetail], tvSeries: []))
                        }
                    }
                }
            } else if let tvSeriesDetail = detail as? TVSeriesDetails {
                if let firstGenre = tvSeriesDetail.genres.first {
                    let existsInAnotherGenre = genreDetails.contains { $0.tvSeries.contains { $0.id == tvSeriesDetail.id } }
                    if !existsInAnotherGenre {
                        if let index = genreDetails.firstIndex(where: { $0.genre == firstGenre.name }) {
                            genreDetails[index].tvSeries.append(tvSeriesDetail)
                        } else {
                            genreDetails.append(GenreDetails(genre: firstGenre.name, movies: [], tvSeries: [tvSeriesDetail]))
                        }
                    }
                }
            }
        }
        return genreDetails
    }
    
    private func generateListButtonTapped() {
         let genreDetails = groupByGenre()
         var formattedList = ""
         for genreDetail in genreDetails {
             formattedList += "\(genreDetail.genre):\n"
             if currentSegmentIndex == 0 {
                 for movieDetail in genreDetail.movies {
                     formattedList += "\(movieDetail.title)\n"
                 }
             } else {
                 for tvSeriesDetail in genreDetail.tvSeries {
                     formattedList += "\(tvSeriesDetail.title ?? "")\n"
                 }
             }
             formattedList += "\n"
         }
         print(formattedList)

         let activityViewController = UIActivityViewController(activityItems: [formattedList], applicationActivities: nil)

         activityViewController.popoverPresentationController?.sourceView = self.view
         activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
         activityViewController.popoverPresentationController?.permittedArrowDirections = []
         present(activityViewController, animated: true, completion: nil)
     }

     
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let genres = currentSegmentIndex == 0 ? movieDetails.compactMap { $0.genres.first?.name } : tvSeriesDetails.compactMap { $0.genres.first?.name }
        return Set(genres).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as! FavoriteTableViewCell
        cell.segmentIndex = currentSegmentIndex
        cell.delegate = self
        
        let genreDetails = groupByGenre()[indexPath.row]
        cell.genre = genreDetails.genre
        cell.movieDetails = genreDetails.movies
        cell.tvSeriesDetails = genreDetails.tvSeries
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension FavoritesViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet {
            self.movieDetails.removeAll()
            self.tvSeriesDetails.removeAll()
            
            self.fetchFavoriteMediaIDs(forSection: self.currentSegmentIndex)
            self.tableView.reloadData()
        }
    }
    func leftButtonTapped() { }
    
    func shareButtonTapped() {
        generateListButtonTapped()
    }
}


extension FavoritesViewController: FilterViewDelegate {
    func segment1() {
        currentSegmentIndex = 0
        fetchFavoriteMediaIDs(forSection: currentSegmentIndex)
        tableView.reloadData()
    }
    
    func segment2() {
        currentSegmentIndex = 1
        fetchFavoriteMediaIDs(forSection: currentSegmentIndex)
        tableView.reloadData()
    }
    
    func segment3() { }
    
    func segment4() {  }
}

extension FavoritesViewController: FavoriteTableViewCellDelegate {
    func didSelectId(_ movie: MovieDetails) {
        router?.showDetailForm(with: movie.id, isMovie: true, viewController: self, animated: true)
    }
    
    func didSelectId(_ tvSeries: TVSeriesDetails) {
        router?.showDetailForm(with: tvSeries.id, isMovie: false, viewController: self, animated: true)
    }
}