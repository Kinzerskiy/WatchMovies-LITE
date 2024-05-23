//
//  CardViewController.swift
//  WatchMovies LITE
//
//  Created by User on 09.05.2024.
//

import UIKit
import VerticalCardSwiper
import CoreData

class CardViewController: UIViewController {
    
    @IBOutlet weak var segmentBarView: UIView!
    @IBOutlet private var cardSwiper: VerticalCardSwiper!
    
    var router: CardsRouting?
    
    let filterView = FilterView.loadView()
    let navigationView = NavigationHeaderView.loadView()
    
    var movies: [Movie] = []
    var tvSeries: [TVSeries] = []
    
    private var currentSegmentIndex = 0
    
    let plusImage = UIImage(systemName: "bookmark.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)).withTintColor(.orange, renderingMode: .alwaysOriginal)
    let minusImage = UIImage(systemName: "eye.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)).withTintColor(.orange, renderingMode: .alwaysOriginal)
    
    lazy var loadMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .orange
        button.addTarget(self, action: #selector(loadMoreButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .orange
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    @objc func loadMoreButtonTapped() {
        switch currentSegmentIndex {
        case 0:
            loadMoreMovies(for: currentSegmentIndex)
        case 1:
            loadMoreTVSeries(for: currentSegmentIndex)
        default:
            break
        }
    }
    
    lazy var plusImageView: UIImageView = {
        let imageView = UIImageView(image: self.plusImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func animatePlusImage() {
        UIView.animate(withDuration: 0.4, animations: {
            self.plusImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                self.plusImageView.transform = .identity
                self.plusImageView.isHidden = true
            }
        }
    }
    
    func animateMinusImage() {
        UIView.animate(withDuration: 0.4, animations: {
            self.minusImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
        }) { _ in
            UIView.animate(withDuration: 0.4) {
                self.minusImageView.transform = .identity
                self.minusImageView.isHidden = true
            }
        }
    }
    
    lazy var minusImageView: UIImageView = {
        let imageView = UIImageView(image: self.minusImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInitialData()
        prepareUI()
        makeNavigationBar()
        prepareSegmenBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        notificationRequest()
    }
    
    func fetchRandomPage() -> Int {
        return Int.random(in: 1...60)
    }
    
    func fetchInitialData() {
        loadingView.startAnimating()
        
        let group = DispatchGroup()
        
        group.enter()
        fetchMovies(page: fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.handleMovieResponse(movies: movies, error: nil)
            case .failure(let error):
                self?.handleMovieResponse(movies: nil, error: error)
            }
            print("Movies fetch completed")
            group.leave()
        }
        
        group.enter()
        fetchTVSeries(page: fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let tvSeries):
                self?.handleTVResponse(tvSeries: tvSeries, error: nil)
            case .failure(let error):
                self?.handleTVResponse(tvSeries: nil, error: error)
            }
            print("TV Series fetch completed")
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("All fetch requests completed")
            self.loadingView.stopAnimating()
            self.cardSwiper.reloadData()
        }
    }



    func prepareUI() {
        cardSwiper.frame = view.bounds
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(nib: UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
        
        view.addSubview(plusImageView)
        view.addSubview(minusImageView)
        view.addSubview(loadMoreButton)
        
        NSLayoutConstraint.activate([
            plusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            minusImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minusImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        
        NSLayoutConstraint.activate([
            loadMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadMoreButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadMoreButton.widthAnchor.constraint(equalToConstant: 80),
            loadMoreButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        plusImageView.isHidden = true
        minusImageView.isHidden = true
        loadMoreButton.isHidden = true
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.actionButton.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        navigationView.actionButton.isHidden = false
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.titleLabel.text = "Let's roll"
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareSegmenBar() {
        let segmentTitles = ["POPULAR MOVIES", "TV ON THE AIR"]
        let font = UIFont.lotaBold(ofSize: 12)
        let color = UIColor.black
        filterView.setSegmentTitles(titles: segmentTitles, font: font, color: color)
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: segmentBarView.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: segmentBarView.leadingAnchor),
            filterView.bottomAnchor.constraint(equalTo: segmentBarView.bottomAnchor),
            filterView.trailingAnchor.constraint(equalTo: segmentBarView.trailingAnchor)
        ])
        filterView.setupView()
    }
    
    func fetchTVSeries(page: Int? = nil, completion: @escaping (Result<[TVSeries], Error>) -> Void) {
        print("Fetching TV series...")

        APIManager.shared.fetchOnTheAirSeries(page: page ?? fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let tvSeries):

                
                self?.tvSeries = tvSeries
                completion(.success(tvSeries))
            case .failure(let error):
                print("Error fetching TV series: \(error.localizedDescription)")

                self?.tvSeries = []
                completion(.success([]))
            }
        }
    }
    
    func fetchMovies(page: Int? = nil, completion: @escaping (Result<[Movie], Error>) -> Void) {
        print("Fetching movies...")

        APIManager.shared.fetchPopularMovies(page: page ?? fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                completion(.success(movies))
            case .failure(let error):
                self?.movies = []
                completion(.success([]))
            }
        }
    }
    
    
    private func handleMovieResponse(movies: [Movie]?, error: Error?) {
        guard let movies = movies else {
            loadingView.stopAnimating()
            return
        }
        
        self.movies = movies
        
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    private func handleTVResponse(tvSeries: [TVSeries]?, error: Error?) {
        guard let tvSeries = tvSeries else {
            loadingView.stopAnimating()
            return
        }
        
        self.tvSeries = tvSeries
        
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    private func loadMoreMovies(for segmentIndex: Int) {
        fetchMovies(page: fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let newMovies):
                DispatchQueue.main.async {
                    self?.movies += newMovies
                    self?.cardSwiper.reloadData()
                    self?.loadMoreButton.isHidden = true
                }
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadMoreTVSeries(for segmentIndex: Int) {
        fetchTVSeries(page: fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let newTVSeries):
                DispatchQueue.main.async {
                    self?.tvSeries += newTVSeries
                    self?.cardSwiper.reloadData()
                    self?.loadMoreButton.isHidden = true
                }
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func notificationRequest() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            
            if granted && !UserDefaults.standard.bool(forKey: "notificationConfirmationShown") {
                UserDefaults.standard.set(true, forKey: "notificationConfirmationShown")
                DispatchQueue.main.async {
                    self.showNotificationConfirmationAlert()
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    fileprivate func showNotificationConfirmationAlert() {
        let alert = UIAlertController(title: "Notifications Enabled",
                                      message: "You will now receive notifications about new TV episodes from favorites.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension CardViewController: VerticalCardSwiperDatasource, VerticalCardSwiperDelegate {
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        switch currentSegmentIndex {
        case 0:
            return movies.count
        case 1:
            return tvSeries.count
        default:
            return 0
        }
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        guard index >= 0 else {
            self.cardSwiper.reloadData()
            return CardCollectionViewCell()
        }
        
        switch currentSegmentIndex {
        case 0:
            if index < movies.count {
                let movie = movies[index]
                let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as! CardCollectionViewCell
                cardCell.fill(withData: movie)
                return cardCell
            }
        case 1:
            if index < tvSeries.count {
                let tvSeries = tvSeries[index]
                let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as! CardCollectionViewCell
                cardCell.fill(withData: tvSeries)
                return cardCell
            }
        default:
            break
        }
        return CardCollectionViewCell()
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        var media: MediaId?
        
        switch currentSegmentIndex {
        case 0:
            if index < movies.count && index >= 0 {
                media = movies[index]
            }
        case 1:
            if index < tvSeries.count && index >= 0 {
                media = tvSeries[index]
            }
        default:
            break
        }
        
        if swipeDirection == .Right, let media = media {
            
            if !FavoritesManager.shared.isMediaFavorite(media: media) {
                FavoritesManager.shared.saveToWatchlist(data: media, watchlistType: .hasWatched)
            }
            minusImageView.isHidden = true
            plusImageView.isHidden = false
            animatePlusImage()
        } else if swipeDirection == .Left, let media = media {
            if !FavoritesManager.shared.isMediaFavorite(media: media) {
                FavoritesManager.shared.saveToWatchlist(data: media, watchlistType: .toWatch)
            }
            plusImageView.isHidden = true
            minusImageView.isHidden = false
            animateMinusImage()
        }
        
        switch currentSegmentIndex {
        case 0:
            if index < tvSeries.count {
                movies.remove(at: index)
            }
        case 1:
            if index < tvSeries.count {
                tvSeries.remove(at: index)
            }
        default:
            break
        }
    }
    
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        let threshold = 5
        
        switch currentSegmentIndex {
        case 0:
            if index == movies.count - threshold {
                loadMoreMovies(for: currentSegmentIndex)
            }
        case 1:
            if index == tvSeries.count - threshold {
                loadMoreTVSeries(for: currentSegmentIndex)
            }
        default:
            break
        }
        
        if index == (cardSwiper.focussedCardIndex ?? 1) - 1 {
            loadMoreButton.isHidden = false
        }
        
        minusImageView.isHidden = true
        plusImageView.isHidden = true
    }
    
    func didTapCard(verticalCardSwiperView: VerticalCardSwiperView, index: Int) {
        var mediaDetails: MediaId?
        
        switch currentSegmentIndex {
        case 0:
            if index < movies.count {
                mediaDetails = movies[index]
                router?.showDetailForm(with: mediaDetails!.id, isMovie: true, viewController: self, animated: false)
            }
        case 1:
            if index < tvSeries.count {
                mediaDetails = tvSeries[index]
                router?.showDetailForm(with: mediaDetails!.id, isMovie: false, viewController: self, animated: false)
            }
        default:
            break
        }
        loadMoreButton.removeFromSuperview()
    }
}

extension CardViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet {
            
        }
    }
    
    func leftButtonTapped() { }
    
    func actionButtonTapped() {
        switch currentSegmentIndex {
        case 0:
            fetchMovies(page: fetchRandomPage()) { [weak self] result in
                switch result {
                case .success(let newMovies):
                    DispatchQueue.main.async {
                        self?.movies += newMovies
                        self?.cardSwiper.reloadData()
                        self?.loadMoreButton.isHidden = true
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
            
        case 1:
            fetchTVSeries(page: fetchRandomPage()) { [weak self] result in
                switch result {
                case .success(let newTVSeries):
                    DispatchQueue.main.async {
                        self?.tvSeries += newTVSeries
                        self?.cardSwiper.reloadData()
                        self?.loadMoreButton.isHidden = true
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
        default:
            break
        }
    }
}

extension CardViewController: FilterViewDelegate {
    func segment1() {
        currentSegmentIndex = 0
        fetchMovies(page: fetchRandomPage()) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.handleMovieResponse(movies: movies, error: nil)
            case .failure(let error):
                self?.handleMovieResponse(movies: nil, error: error)
            }
            DispatchQueue.main.async {
                self?.cardSwiper.reloadData()
            }
        }
    }
    
    func segment2() {
        currentSegmentIndex = 1
        fetchTVSeries(page: fetchRandomPage()) { [weak self] result in
            
            switch result {
            case .success(let tvSeries):
                self?.handleTVResponse(tvSeries: tvSeries, error: nil)
            case .failure(let error):
                self?.handleMovieResponse(movies: nil, error: error)
            }
            DispatchQueue.main.async {
                self?.cardSwiper.reloadData()
            }
        }
    }
    
    func segment3() { }
    
    func segment4() { }
}
