//
//  DescriptionTableViewCell.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import SDWebImage

class DescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviewPoster: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    
    func prepareUI() {
        moviewPoster.clipsToBounds = true
        moviewPoster.contentMode = .scaleAspectFit
        contentView.isUserInteractionEnabled = false
        descriptionText.textContainerInset = UIEdgeInsets.zero
        descriptionText.textColor = UIColor.black
        descriptionText.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    func fill(with movie: MovieListResponse.MovieList) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURL + movie.posterPath)
        moviewPoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder_image"))
        print("Overview Text: \(movie.overview)")
        descriptionText.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
    }
    
}
