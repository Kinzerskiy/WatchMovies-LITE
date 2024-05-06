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
    
    var person: Person?
    var movieCastMember: [Movie] = []
    var tvCastMember: [TVSeriesMember] = []
    
    var router: MainRouting?
    let apiManager = APIManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareTableView()
        self.fetchCast(isMovie: isMovie!)
        self.fetchPersonDetails()
    }
    
    func fetchPersonDetails() {
        guard let id = pesonId else { return }
        
        apiManager.fetchPersonDetails(personId: id) { [weak self] (response, error) in
            guard let self = self, let response = response else { return }
            self.person = response
        }
    }
    
    func fetchCast(isMovie: Bool) {
        guard let id = pesonId else { return }
        
        if isMovie {
            apiManager.fetchPersonMoviePersonCredits(personId: id) { [weak self] (response, error) in
                guard let self = self else { return }
              
                if let cast = response?.cast {
                    self.movieCastMember = cast
                }
            }
        } else {
            apiManager.fetchPersonTVPersonCredits(personId: id) { [weak self] (response, error) in
                guard let self = self else { return }
                
                if let cast = response?.cast {
                    self.tvCastMember = cast
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
        case 1: return UITableView.automaticDimension
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
            return cell
        }
        return UITableViewCell()
    }
}
