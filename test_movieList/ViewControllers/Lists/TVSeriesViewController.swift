//
//  TVSeriesViewController.swift
//  test_movieList
//
//  Created by User on 19.04.2024.
//

import UIKit

class TVSeriesViewController: UIViewController {
    
    @IBOutlet weak var segmentBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var router: TVSeriesListRouting?
    let navigationView = NavigationHeaderView.loadView()
    let filterView = FilterView.loadView()
    let apiManager = APIManager()
    
    var tvSeries: [TVSeries] = []
    private var currentPage = [0, 0, 0, 0]
    private var currentSegmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        makeNavigationBar()
        prepareSegmenBar()
        prepareUI()
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.titleImage.image = UIImage(named: "TV Series")
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareSegmenBar() {
        let segmentTitles = ["Today", "On the air", "Top", "Popular"]
        filterView.setSegmentTitles(titles: segmentTitles)
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
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
        fetchTVSeries(for: currentSegmentIndex, page: 1) { tvSeries, error, segmentIndex in
               self.handleFetchResponse(tvSeries: tvSeries, error: error, segmentIndex: segmentIndex)
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

extension TVSeriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let tvSeriesIndex = indexPath.item
        if tvSeriesIndex < tvSeries.count {
            let tvSeries = tvSeries[tvSeriesIndex]
            cell.fill(withData: tvSeries)
//            cell.longPressHandler = { [weak self] in
//                self?.handleLongPressOnCell(with: movie)
//            }
        }
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadMoreMoviesIfNeeded(for: currentSegmentIndex)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}



extension TVSeriesViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() { }
}


extension TVSeriesViewController: FilterViewDelegate {
    
    func segment1() {
        currentSegmentIndex = 0
        fetchTVSeries(for: currentSegmentIndex, page: 1) { tvSeries, error, segmentIndex in
            self.handleFetchResponse(tvSeries: tvSeries, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment2() {
        currentSegmentIndex = 1
        fetchTVSeries(for: currentSegmentIndex, page: 1) { tvSeries, error, segmentIndex in
            self.handleFetchResponse(tvSeries: tvSeries, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment3() {
        currentSegmentIndex = 2
        fetchTVSeries(for: currentSegmentIndex, page: 1) { tvSeries, error, segmentIndex in
            self.handleFetchResponse(tvSeries: tvSeries, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func segment4() {
        currentSegmentIndex = 3
        fetchTVSeries(for: currentSegmentIndex, page: 1) { tvSeries, error, segmentIndex in
            self.handleFetchResponse(tvSeries: tvSeries, error: error, segmentIndex: segmentIndex)
        }
        DispatchQueue.main.async {
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    func searchTapped() {
        
    }
    
    
    private func fetchTVSeries(for segmentIndex: Int, page: Int, completion: @escaping ([TVSeries]?, Error?, Int) -> Void) {
        switch segmentIndex {
        case 0:
            apiManager.fetchAiringTodaySeries(page: page) { tvSeries, error in
                completion(tvSeries, error, segmentIndex)
            }
        case 1:
            apiManager.fetchOnTheAirSeries(page: page) { tvSeries, error in
                completion(tvSeries, error, segmentIndex)
            }
        case 2:
            apiManager.fetchPopularSeries(page: page) { tvSeries, error in
                completion(tvSeries, error, segmentIndex)
            }
        case 3:
            apiManager.fetchTopRatedSeries(page: page) { tvSeries, error in
                completion(tvSeries, error, segmentIndex)
            }
        default:
            break
        }
    }


       
    private func handleFetchResponse(tvSeries: [TVSeries]?, error: Error?, segmentIndex: Int) {
        guard let tvSeries = tvSeries else {
            showAlertDialog(title: "Error", message: error?.localizedDescription ?? "Unknown error")
            return
        }

        self.tvSeries = tvSeries

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

       
    private func loadMoreMoviesIfNeeded(for segmentIndex: Int) {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let lastVisibleIndexPath = visibleIndexPaths.last ?? IndexPath(item: 0, section: 0)

        if lastVisibleIndexPath.item >= tvSeries.count - 4 {
            currentPage[segmentIndex] += 1
            fetchTVSeries(for: segmentIndex, page: currentPage[segmentIndex]) { tvSeries, error, segmentIndex in
                guard let tvSeries = tvSeries else { return }
                self.tvSeries += tvSeries
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}