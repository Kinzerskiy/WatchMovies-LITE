//
//  SearchResultViewController.swift
//  test_movieList
//
//  Created by User on 27.04.2024.
//

import UIKit

enum MediaType {
    case movie
    case tvSeries
}

class SearchResultViewController: UIViewController {

    let navigationView = NavigationHeaderView.loadView()
    var router: SearchRouting?
    var isMovie: Bool?
    var firsId: Int?
    
    var genreName: String?
    var ganreID: String?
    var year: String?
    var includeAdult: Bool?
    
    var currentPage = 1
    var isFetchingData = false
    
    var searchResults: [Any] = []
    let apiManager = APIManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBar()
        prepareCollectionView()
    }
    
    func makeNavigationBar() {
        navigationView.delegate = self
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.titleView = navigationView
        navigationView.titleImage.isHidden = true
        navigationView.titleName.textAlignment = .center
        navigationView.titleName.text = genreName
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
    
    func fetchSearchResults(page: Int, genreName: String? = nil, genreID: String? = nil, completion: @escaping ([Any]?, Error?) -> Void) {
        let mediaType: MediaType = isMovie ?? false ? .movie : .tvSeries

        switch mediaType {
        case .movie:
            apiManager.fetchSearchMovies(page: page, includeAdult: includeAdult, primaryReleaseYear: year, ganre: genreID) { movies, error in
                completion(movies, error)
                if let error = error {
                    self.showAlertDialog(title: "Error", message: error.localizedDescription)
                }
            }
        case .tvSeries:
            apiManager.fetchSearchTVSeries(page: page, includeAdult: includeAdult, firstAirDateYear: year, genre: genreID) { tvSeries, error in
                completion(tvSeries as [Any], nil)
                if let error = error {
                    self.showAlertDialog(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    private func loadMoreSearchResultsIfNeeded() {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let lastVisibleIndexPath = visibleIndexPaths.last ?? IndexPath(item: 0, section: 0)

        if lastVisibleIndexPath.item >= searchResults.count - 4 {
            currentPage += 1
            fetchSearchResults(page: currentPage, genreName: genreName, genreID: ganreID) { [weak self] newSearchResults, error in
                guard let self = self, let newSearchResults = newSearchResults else { return }
                self.searchResults += newSearchResults
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

}

extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = searchResults[indexPath.item]
        cell.fill(withData: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMedia = searchResults[indexPath.item]
        if let movie = selectedMedia as? Movie {
            router?.showDetailForm(with: movie.id, isMovie: true, viewController: self, animated: true)
        } else if let tvSeries = selectedMedia as? TVSeries {
            router?.showDetailForm(with: tvSeries.id, isMovie: false, viewController: self, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreSearchResultsIfNeeded()
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


extension SearchResultViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
