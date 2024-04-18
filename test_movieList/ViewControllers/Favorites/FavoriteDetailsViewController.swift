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
    @IBOutlet weak var moviePoster: UIImageView!
    
    var favoriteMovie: Movie?
    var router: FavoritesRouting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    func prepareUI() {
//        let baseURL = "https://image.tmdb.org/t/p/w500"
//        let posterURL = URL(string: baseURL + (favoriteMovie?.posterImage ?? ""))
//        
//        contentView.isUserInteractionEnabled = false
//        contentView.layer.cornerRadius = 8
//        movieName.text = favoriteMovie?.title
//        movieDetails.text = favoriteMovie?.releaseDate
//        
//        moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder_image"))
//        
//        overviewText.text = favoriteMovie?.overview
//        overviewText.textContainerInset = UIEdgeInsets.zero
    }
}
