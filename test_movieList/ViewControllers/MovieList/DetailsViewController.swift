//
//  DetailsViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedMovie: MovieListResponse.MovieList?
    var router: ListRouting?
    let navigationView = NavigationHeaderView.loadView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        makeNavigationBar()
    }
    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableViewCell")
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
        navigationView.titleName.text = selectedMovie?.title
        navigationView.titleImage.isHidden = true
        navigationView.titleName.textAlignment = .center
    }
}

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell else {
            return UITableViewCell()
        }
        if let movie = selectedMovie {
            cell.fill(with: movie)
        }
        return cell
    }
}

extension DetailsViewController: NavigationHeaderViewDelegate {
    
    func leftButtonTapped() {
        router?.dissmiss(viewController: self, animated: true, completion: nil)
    }
}
