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
    
    var longPressHandler: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        addLongPressGesture()
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
        } else
        if let movie = data as? Movie {
            titleLabel.text = movie.title
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURL + (movie.posterPath ?? ""))
            posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        }
    }
    
    private func addLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        contentView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            longPressHandler?()
        }
    }
}

extension ListCollectionViewCell: ListCellConfigurable {
    func configure(withData data: Any) {
        fill(withData: data)
    }
}
