//
//  FavoriteTableViewCell.swift
//  test_movieList
//
//  Created by User on 03.02.2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieButton: UIButton!
    
    var favoriteActionHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
//    
//    func fill(with movie: Movie) {
//        movieLabel.text = movie.title
//        let baseURL = "https://image.tmdb.org/t/p/w500"
//        let posterURL = URL(string: baseURL + (movie.posterImage ?? ""))
//        moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder_image"))
//        
//        
//        if movie.isFavorite {
//            movieButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        } else {
//            movieButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//        movieButton.tintColor = .orange
//        movieButton.isSelected = false
//    }
    
    
    @IBAction func favoriteAction(_ sender: UIButton) {
//        favoriteActionHandler?()
//        if sender.isSelected {
//            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        } else {
//            sender.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
    }
}
