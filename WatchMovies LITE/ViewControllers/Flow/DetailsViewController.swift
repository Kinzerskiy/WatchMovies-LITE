//
//  DetailsViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    var selectedId: Int?
    var movieDetails: MovieDetails?
    var tvSeriesDetails: TVSeriesDetails?
    var similarMovies: [SimilarMovie] = []
    var similarTVSeries: [SimilarTVSeries] = []
    var videoId: String?
    
    var isMovie: Bool?
    
    var router: MainRouting?
    let navigationView = NavigationHeaderView.loadView()
    let apiManager = APIManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        fetchMediaDetails(isMovie: isMovie!, completion:  { [weak self] in
            DispatchQueue.main.async {
                self?.makeNavigationBar()
                self?.tableView.reloadData()
                self?.tableView.alpha = 1.0
            }
        })
        tableView.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }

    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(UINib(nibName: "OverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OverviewTableViewCell")
        tableView.register(UINib(nibName: "SimilarTableViewCell", bundle: nil), forCellReuseIdentifier: "SimilarTableViewCell")
        tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
    }
    
    func makeNavigationBar() {
        navigationView.delegate = self
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = navigationView
        
        if isMovie! {
            navigationView.titleName.text = movieDetails?.title
        } else {
            navigationView.titleName.text = tvSeriesDetails?.name
        }
        navigationView.titleImage.isHidden = true
        navigationView.titleName.textAlignment = .center
    }
    
    func fetchMediaDetails(isMovie: Bool, completion: @escaping () -> Void) {
        guard let id = selectedId else { return }
        
        if isMovie {
            apiManager.fetchMovieDetails(movieId: id) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                self.movieDetails = response
                self.fetchSimilarMedia(completion: completion)
                self.fetchVideos()
            }
        } else {
            apiManager.fetchTVSeriesDetails(seriesId: id) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                self.tvSeriesDetails = response
                self.fetchSimilarMedia(completion: completion)
                self.fetchVideos()
            }
        }
    }
    
    func fetchSimilarMedia(completion: @escaping () -> Void) {
        guard let id = selectedId else { return }
        
        if isMovie == true {
            apiManager.fetchSimilarMovies(movieId: id) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                self.similarMovies = response.results
                completion()
            }
        } else {
            apiManager.fetchSimilarTVSeries(seriesId: id) { [weak self] (response, error) in
                guard let self = self, let response = response else { return }
                self.similarTVSeries = response.results
                completion()
            }
        }
    }
    
    func fetchVideos() {
            guard let id = selectedId else { return }
            if isMovie == true {
                apiManager.fetchMovieVideos(movieId: id) { [weak self] (response, error) in
                    guard let self = self, let response = response else { return }
                    let trailers = response.results.filter { $0.type.lowercased() == "trailer" }
                    if let trailer = trailers.first {
                        self.videoId = trailer.key
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                apiManager.fetchTVVideos(tvSeriesId: id) { [weak self] (response, error) in
                    guard let self = self, let response = response else { return }
                    let trailers = response.results.filter { $0.type.lowercased() == "trailer" }
                    if let trailer = trailers.first {
                        self.videoId = trailer.key
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    private func checkIfInFavorites(mediaId: Int) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mediaId == %ld", Int64(mediaId))
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error checking if in favorites: \(error)")
            return false
        }
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 2
        if videoId != nil {
            rowCount += 1
        }
        if !similarMovies.isEmpty || !similarTVSeries.isEmpty {
            rowCount += 1
        }
        return rowCount
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return UITableView.automaticDimension
        case 1: return 200
        case 2: return 200
        case 3: return 300
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            if let movieDetails = movieDetails {
                cell.fill(with: movieDetails)
                cell.updateFavoriteStatus(isFavorite: checkIfInFavorites(mediaId: Int(Int64(movieDetails.id))))
            } else if let tvSeriesDetails = tvSeriesDetails {
                cell.fill(with: tvSeriesDetails)
                cell.updateFavoriteStatus(isFavorite: checkIfInFavorites(mediaId: Int(Int64(tvSeriesDetails.id))))
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as! OverviewTableViewCell
            if let movieDetails = movieDetails {
                cell.fill(with: movieDetails)
            } else if let tvSeriesDetails = tvSeriesDetails {
                cell.fill(with: tvSeriesDetails)
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
           
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarTableViewCell", for: indexPath) as! SimilarTableViewCell
            if movieDetails != nil {
                cell.similarMovie = similarMovies
            } else {
                cell.similarTVSeries = similarTVSeries
            }
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if let videoCell = cell as? VideoTableViewCell {
               videoCell.fill(with: videoId ?? "")
           }
       }
}

extension DetailsViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController: SimilarTableViewCellDelegate {
    
    func didSelectSimilarTVSeries(_ tvSeries: SimilarTVSeries) {
        selectedId = tvSeries.id
        similarMovies.removeAll()
        fetchMediaDetails(isMovie: false) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                self.makeNavigationBar()
            }
            self.videoId = nil
        }
        fetchSimilarMedia {
            DispatchQueue.main.async {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SimilarTableViewCell {
                    cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func didSelectSimilarMovie(_ movie: SimilarMovie) {
        selectedId = movie.id
        similarMovies.removeAll()
        fetchMediaDetails(isMovie: true) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
                self.makeNavigationBar()
            }
            self.videoId = nil
        }
        fetchSimilarMedia {
            DispatchQueue.main.async {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SimilarTableViewCell {
                    cell.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
                }
                self.tableView.reloadData()
            }
        }
    }
}
