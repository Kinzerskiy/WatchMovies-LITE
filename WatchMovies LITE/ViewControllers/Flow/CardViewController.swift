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
    
    let apiManager = APIManager()
    var movies: [Movie] = []
    var tvSeries: [TVSeries] = []
    
    private var currentSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInitialData()
        prepareUI()
        makeNavigationBar()
        prepareSegmenBar()
    }
    
    func fetchRandomPage() -> Int {
        return Int.random(in: 1...100)
    }
    
    func fetchInitialData() {
        let group = DispatchGroup()
        
        group.enter()
        fetchMovies(page: fetchRandomPage()) { movies, error in
            self.handleMovieResponse(movies: movies, error: error)
            group.leave()
        }
        
        group.enter()
        fetchTVSeries(page: fetchRandomPage()) { tvSeries, error in
            self.handleTVResponse(tvSeries: tvSeries, error: error)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.cardSwiper.reloadData()
        }
    }
    
    func prepareUI() {
        cardSwiper.frame = view.bounds
        cardSwiper.datasource = self
        cardSwiper.delegate = self
        cardSwiper.register(nib: UINib(nibName: "CardCell", bundle: nil), forCellWithReuseIdentifier: "CardCell")
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.titleLabel.text = "Random"
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareSegmenBar() {
        let segmentTitles = ["Movies", "TV"]
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
        apiManager.fetchPopularSeries(page: fetchRandomPage()) { tvSeries, error in
            completion(tvSeries, error)
            if let error = error {
                self.showAlertDialog(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func fetchMovies(page: Int? = nil, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        apiManager.fetchPopularMovies(page: fetchRandomPage()) { movies, error in
            completion(movies, error)
            if let error = error {
                self.showAlertDialog(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func handleMovieResponse(movies: [Movie]?, error: Error?) {
        guard let movies = movies else {
            showAlertDialog(title: "Error", message: error?.localizedDescription ?? "Unknown error")
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
            return
        }
        
        self.tvSeries = tvSeries
        
        DispatchQueue.main.async {
            self.cardSwiper.reloadData()
        }
    }
    
    private func loadMoreMoviesIfNeeded(for segmentIndex: Int) {
        fetchMovies(page: fetchRandomPage()) { movies, error in
            guard let newMovies = movies else {
                return
            }
            DispatchQueue.main.async {
                let startIndex = self.movies.count
                self.movies += newMovies
                let indexes = (startIndex..<self.movies.count).map { $0 }
                self.cardSwiper.insertCards(at: indexes)
            }
        }
    }
    
    private func loadMoreTVSeriesIfNeeded(for segmentIndex: Int) {
        fetchTVSeries(page: fetchRandomPage()) { tvSeries, error in
            guard let newTVSeries = tvSeries else {
                return
            }
            let startIndex = self.tvSeries.count
            self.tvSeries += newTVSeries
            let indexes = (startIndex..<self.tvSeries.count).map { $0 }
            self.cardSwiper.insertCards(at: indexes)
        }
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
        if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: index) as? CardCollectionViewCell {
            
            switch currentSegmentIndex {
            case 0:
                let movie = movies[index]
                cardCell.fill(withData: movie)
            case 1:
                let tvSeries = tvSeries[index]
                cardCell.fill(withData: tvSeries)
            default:
                break
            }
            return cardCell
        }
        return CardCollectionViewCell()
    }
    
    func didScroll(verticalCardSwiperView: VerticalCardSwiperView) {
        if let currentIndex = cardSwiper.focussedCardIndex {
            _ = cardSwiper.scrollToCard(at: currentIndex + 1, animated: true)
        }
    }
    
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        var media: MediaDetails?
        
        switch currentSegmentIndex {
        case 0:
            if index < movies.count {
                media = movies[index]
            }
        case 1:
            if index < tvSeries.count {
                media = tvSeries[index]
            }
        default:
            break
        }
        
        if swipeDirection == .Right, let media = media {
            FavoritesManager.shared.saveToFavorites(data: media)
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
        if index == movies.count - threshold {
            loadMoreMoviesIfNeeded(for: currentSegmentIndex)
        }
    }
}

extension CardViewController: NavigationHeaderViewDelegate {
    func rightButtonTapped() {
        showRateAndSupportActionSheet()
    }
    
    func leftButtonTapped() { }
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



