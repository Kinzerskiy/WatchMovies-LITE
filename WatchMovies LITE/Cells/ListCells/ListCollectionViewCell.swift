//
//  ListCollectionViewCell.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import SDWebImage

protocol ListCellConfigurable {
    func configure(withData data: Any)
}

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    func prepareUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
       
        if let placeholderImageName = posterImageView.image?.accessibilityIdentifier, placeholderImageName == "Popcorn" {
            posterImageView.contentMode = .scaleAspectFit
        } else {
            posterImageView.contentMode = .scaleAspectFill
        }
        
        posterImageView.clipsToBounds = true
        blurView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        contentView.isUserInteractionEnabled = true
    }
    
    func fill(withData data: Any) {
        if let tvShow = data as? TVSeries {
            titleLabel.text = tvShow.name
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (tvShow.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let movie = data as? Movie {
            titleLabel.text = movie.title
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (movie.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let movieCast = data as? MovieCastMember {
            titleLabel.text = movieCast.originalTitle
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (movieCast.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let tvCast = data as? TVSeriesMember {
            titleLabel.text = tvCast.originalName
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (tvCast.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let favorite = data as? Favorites {
            titleLabel.text = favorite.title
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (favorite.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder_image"))
        }
    }
}

extension ListCollectionViewCell: ListCellConfigurable {
    func configure(withData data: Any) {
        fill(withData: data)
    }
}
