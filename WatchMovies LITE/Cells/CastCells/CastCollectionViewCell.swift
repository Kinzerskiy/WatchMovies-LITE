//
//  CastCollectionViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var knownForDepartmentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        personImage.layer.borderWidth = 2.0
        personImage.layer.masksToBounds = false
        personImage.layer.borderColor = UIColor.orange.cgColor
        personImage.layer.cornerRadius = personImage.frame.size.width / 2
        personImage.clipsToBounds = true
    }
    
    func fill(with cast: MovieCast) {
        nameLabel.text = cast.name
        knownForDepartmentLabel.text = cast.knownForDepartment
        if let profilePath = cast.profilePath {
            let imageUrlString = "https://image.tmdb.org/t/p/w200\(profilePath)"
            personImage.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: "Popcorn"), completed: { [weak self] (image, error, cacheType, url) in
                if let image = image {
                    self?.personImage.image = image
                }
            })
        } else {
            personImage.image = UIImage(named: "Popcorn")
        }
    }

    func fill(with cast: TVSeriesCast) {
        nameLabel.text = cast.name
        knownForDepartmentLabel.text = cast.knownForDepartment
        if let profilePath = cast.profilePath {
            let imageUrlString = "https://image.tmdb.org/t/p/w200\(profilePath)"
            personImage.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: "Popcorn"), completed: { [weak self] (image, error, cacheType, url) in
                if let image = image {
                    self?.personImage.image = image
                }
            })
        } else {
            personImage.image = UIImage(named: "Popcorn")
        }
    }

}
