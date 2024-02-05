//
//  FavoriteDetailsViewController.swift
//  test_movieList
//
//  Created by User on 03.02.2024.
//

import UIKit

class FavoriteDetailsViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieDetails: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    
    var favoriteMovie: Movie?
    var router: FavoritesRouting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
        contentView.isUserInteractionEnabled = false
        contentView.layer.cornerRadius = 8
        movieName.text = favoriteMovie?.title
        movieDetails.text = favoriteMovie?.releaseDate
        overviewText.text = favoriteMovie?.overview
        overviewText.textContainerInset = UIEdgeInsets.zero
    }
}
