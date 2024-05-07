//
//  PersonViewController.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import UIKit

class PersonViewController: UIViewController {
    
    var isMovie: Bool?
    var pesonId: Int?
    var selectedMediaId: Int?
    
    var person: Person?
    var movieCastMember: [MovieCastMember] = []
    var tvCastMember: [TVSeriesMember] = []
    
    var router: MainRouting?
    let apiManager = APIManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTableView()
        fetchPersonDetailsAndCast()
    }
    
    func fetchPersonDetailsAndCast() {
        guard let id = pesonId else { return }
        
        apiManager.fetchPersonDetails(personId: id) { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            self.person = response
            if let isMovie = isMovie {
                self.fetchCast(isMovie: isMovie)
            }
        }
    }
    
    func fetchCast(isMovie: Bool) {
        guard let id = pesonId else { return }
        
        if isMovie {
            apiManager.fetchPersonMoviePersonCredits(personId: id) { [weak self] (response, error) in
                guard let self = self else { return }
                if let cast = response?.cast {
                    self.movieCastMember = cast
                    self.tableView.reloadData()
                }
            }
        } else {
            apiManager.fetchPersonTVPersonCredits(personId: id) { [weak self] (response, error) in
                guard let self = self else { return }
                if let cast = response?.cast {
                    self.tvCastMember = cast
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PersonPhotoTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PersonPhotoTableViewCell")
        tableView.register(UINib(nibName: "CastMediaTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CastMediaTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        tableView.rowHeight = 0
    }
}

extension PersonViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 450
        case 1: return 600
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonPhotoTableViewCell", for: indexPath) as! PersonPhotoTableViewCell
            guard let person = person else { return cell }
            cell.fill(with: person)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CastMediaTableViewCell", for: indexPath) as! CastMediaTableViewCell
            if person != nil {
                cell.movieCast = movieCastMember
            } else {
                cell.tvCast = tvCastMember
            }
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension PersonViewController: CastMediaTableViewCellDelegate {
    func didSelectMovieCast(_ movieCast: MovieCastMember) {
        selectedMediaId = movieCast.id
        dismiss(animated: true) {
            self.router?.showDetailForm(with: self.selectedMediaId!, isMovie: true, viewController: self, animated: true)
        }
    }

    func didSelectTVSeriesCast(_ tvCast: TVSeriesMember) {
        selectedMediaId = tvCast.id
        dismiss(animated: true) {
            self.router?.showDetailForm(with: self.selectedMediaId!, isMovie: false, viewController: self, animated: true)
        }
    }
}
