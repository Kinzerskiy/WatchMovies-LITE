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
        notificationRequest()
        fetchInitialData()
        prepareUI()
        makeNavigationBar()
        prepareSegmenBar()
    }
    
    func fetchRandomPage() -> Int {
        return Int.random(in: 1...60)
    }
    
    func fetchInitialData() {
        loadingView.startAnimating()
        
        let group = DispatchGroup()
        
        group.enter()
        fetchMovies(page: fetchRandomPage()) { [weak self] movies, error in
            self?.handleMovieResponse(movies: movies, error: error)
            group.leave()
        }
        
        group.enter()
        fetchTVSeries(page: fetchRandomPage()) { [weak self] tvSeries, error in
            self?.handleTVResponse(tvSeries: tvSeries, error: error)
            group.leave()
        }
        
        group.notify(queue: .main) {
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
    
    private func fetchTVSeries(page: Int? = nil, completion: @escaping ([TVSeries]?, Error?) -> Void) {
        APIManager.shared.fetchOnTheAirSeries(page: fetchRandomPage()) { [weak self] tvSeries, error in
            completion(tvSeries, error)
            if let error = error {
                self?.showAlertDialog(title: "Error", message: error.localizedDescription)
            } else {
                self?.cardSwiper.reloadData()
            }
        }
    }
    
    private func fetchMovies(page: Int? = nil, completion: @escaping ([Movie]?, Error?) -> Void) {
        APIManager.shared.fetchPopularMovies(page: fetchRandomPage()) { [weak self] movies, error in
            completion(movies, error)
            if let error = error {
                self?.showAlertDialog(title: "Error", message: error.localizedDescription)
            } else {
                self?.cardSwiper.reloadData()
            }
        }
    }
    
    private func handleMovieResponse(movies: [Movie]?, error: Error?) {
        guard let movies = movies else {
            showAlertDialog(title: "Error", message: error?.localizedDescription ?? "Unknown error")
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
            showAlertDialog(title: "Error", message: error?.localizedDescription ?? "Unknown error")
            loadingView.stopAnimating()
            return
        }
        
        self.tvSeries = tvSeries
        
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    private func loadMoreMovies(for segmentIndex: Int) {
        fetchMovies(page: fetchRandomPage()) { movies, error in
            guard let newMovies = movies else {
                return
            }
            DispatchQueue.main.async {
                self.movies += newMovies
                self.cardSwiper.reloadData()
                self.loadMoreButton.isHidden = true
            }
        }
    }
    
    private func loadMoreTVSeries(for segmentIndex: Int) {
        fetchMovies(page: fetchRandomPage()) { tvSeries, error in
            guard let newTVSeries = tvSeries else {
                return
            }
            DispatchQueue.main.async {
                self.movies += newTVSeries
                self.cardSwiper.reloadData()
                self.loadMoreButton.isHidden = true
            }
        }
    }
    
    fileprivate func notificationRequest() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        UIApplication.shared.registerForRemoteNotifications()
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
            fetchMovies(page: fetchRandomPage()) { [weak self] movies, error in
                guard let newMovies = movies else {
                    return
                }
                DispatchQueue.main.async {
                    self?.movies = newMovies
                    self?.cardSwiper.reloadData()
                }
            }
        case 1:
            fetchTVSeries(page: fetchRandomPage()) { [weak self] tvSeries, error in
                guard let newTVSeries = tvSeries else {
                    return
                }
                DispatchQueue.main.async {
                    self?.tvSeries = newTVSeries
                    self?.cardSwiper.reloadData()
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
        fetchMovies(page: fetchRandomPage()) { movies, error in
            self.handleMovieResponse(movies: movies, error: error)
        }
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    func segment2() {
        currentSegmentIndex = 1
        fetchTVSeries(page: fetchRandomPage()) { tvSeries, error in
            self.handleTVResponse(tvSeries: tvSeries, error: error)
        }
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    func segment3() { }
    
    func segment4() { }
}
