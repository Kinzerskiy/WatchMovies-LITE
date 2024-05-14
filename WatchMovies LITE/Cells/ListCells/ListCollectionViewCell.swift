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
    @IBOutlet weak var watchedImage: UIImageView!
    @IBOutlet weak var isToWatchImage: UIImageView!
    
    
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
        
        watchedImage.isHidden = true
        isToWatchImage.isHidden = true
    }
    
    func fill(withData data: Any) {
        if let tvShow = data as? TVSeries {
            if let favorite = FavoritesManager.shared.fetchFavoriteMedia(for: tvShow) {
                if favorite.isWatchingType {
                    watchedImage.isHidden = false
                    isToWatchImage.isHidden = true
                } else if !favorite.isWatchingType {
                    watchedImage.isHidden = true
                    isToWatchImage.isHidden = false
                }
            } else {
                watchedImage.isHidden = true
                isToWatchImage.isHidden = true
            }
            titleLabel.text = tvShow.name
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (tvShow.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let movie = data as? Movie {
            if let favorite = FavoritesManager.shared.fetchFavoriteMedia(for: movie) {
                if favorite.isWatchingType {
                    watchedImage.isHidden = false
                    isToWatchImage.isHidden = true
                } else if !favorite.isWatchingType {
                    watchedImage.isHidden = true
                    isToWatchImage.isHidden = false
                }
            } else {
                watchedImage.isHidden = true
                isToWatchImage.isHidden = true
            }
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
        } else if let movie = data as? MovieDetails {
            titleLabel.text = movie.title
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (movie.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let tvSeries = data as? TVSeriesDetails {
            titleLabel.text = tvSeries.name
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (tvSeries.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        }
    }
}

extension ListCollectionViewCell: ListCellConfigurable {
    func configure(withData data: Any) {
        fill(withData: data)
    }
}
