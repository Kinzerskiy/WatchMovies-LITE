//
//  CardCollectionViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 09.05.2024.
//

import UIKit
import VerticalCardSwiper

class CardCollectionViewCell: CardCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 12
    }
    
    func fill(withData data: Any) {
        if let tvShow = data as? TVSeries {
            nameLabel.text = tvShow.name
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (tvShow.posterPath ?? ""))
            imageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        } else if let movie = data as? Movie {
            nameLabel.text = movie.title
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (movie.posterPath ?? ""))
            imageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        }
    }
}
