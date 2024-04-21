//
//  DetailsViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedId: Int?
    var movieDetails: MovieDetailsResponse?
    var similarMovies: [SimilarMovie] = []
    
    var router: MainRouting?
    let navigationView = NavigationHeaderView.loadView()
    let apiManager =  APIManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovieDetails { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.makeNavigationBar()
            }
        }
    }
    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DescriptionTableViewCell")
        tableView.register(UINib(nibName: "OverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OverviewTableViewCell")
        tableView.register(UINib(nibName: "SimilarTableViewCell", bundle: nil), forCellReuseIdentifier: "SimilarTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    func makeNavigationBar() {
        navigationView.delegate = self
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        navigationItem.titleView = navigationView
        navigationView.titleName.text = movieDetails?.title
        navigationView.titleImage.isHidden = true
        navigationView.titleName.textAlignment = .center
    }
    
    func fetchMovieDetails(completion: @escaping () -> Void) {
        guard let id = selectedId else { return }
        
        apiManager.fetchMovieDetails(movieId: id) { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            self.movieDetails = response
            self.fetchSimilarMovies {
                completion()
            }
        }
    }
    
    func fetchSimilarMovies(completion: @escaping () -> Void) {
        guard similarMovies.isEmpty else {
            completion()
            return
        }
        
        guard let id = selectedId else { return }
        apiManager.fetchSimilarMovies(movieId: id) { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            self.similarMovies = response.results
            completion()
        }
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 300
        case 2: return 400
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell else {
                return UITableViewCell()
            }
            if selectedId != nil {
                cell.fill(with: movieDetails)
            }
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewTableViewCell else {
                return UITableViewCell()
            }
            cell.fill(with: movieDetails)
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarTableViewCell", for: indexPath) as? SimilarTableViewCell else {
                return UITableViewCell()
            }
            cell.similarMovies = similarMovies
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension DetailsViewController: NavigationHeaderViewDelegate {
    
    func leftButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
