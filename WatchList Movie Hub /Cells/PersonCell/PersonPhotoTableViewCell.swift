//
//  PersonDetailsTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import UIKit

class PersonPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.lotaBold(ofSize: 30)
        nameLabel.textColor = UIColor.white
    }
    
    func fill(with person: Person) {
        nameLabel.text = person.name
        if let posterPath = person.profilePath {
            let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            personImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "Popcorn"))
            
        }
    }
}
