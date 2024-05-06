//
//  SimilarCollectionViewCell.swift
//  test_movieList
//
//  Created by User on 21.04.2024.
//

import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        if let placeholderImageName = posterImage.image?.accessibilityIdentifier, placeholderImageName == "Popcorn" {
            posterImage.contentMode = .scaleAspectFit
        } else {
            posterImage.contentMode = .scaleAspectFill
        }
    }
    
    func prepareUI() {
        posterImage.layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }

    func fill(with media: Any) {
        if let similarMovie = media as? SimilarMovie {
            if let posterPath = similarMovie.posterPath {
                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                posterImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "Popcorn"))
            }
        } else if let similarTVSeries = media as? SimilarTVSeries {
            if let posterPath = similarTVSeries.posterPath {
                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                posterImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "Popcorn"))
            }
        }
    }
}
