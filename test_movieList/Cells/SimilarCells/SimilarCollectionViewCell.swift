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
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }
    
    func fill(with media: Any) {
        if let similarMovie = media as? SimilarMovie {
            if let posterPath = similarMovie.posterPath {
                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                posterImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "placeholder"))
            }
        } else if let similarTVSeries = media as? SimilarTVSeries {
            if let posterPath = similarTVSeries.posterPath {
                let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                posterImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
}
