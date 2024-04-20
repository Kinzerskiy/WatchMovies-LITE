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
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var ganreName: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    func prepareUI() {
        moviewPoster.clipsToBounds = true
        moviewPoster.contentMode = .scaleAspectFit
        moviewPoster.layer.shadowColor = UIColor.black.cgColor
        moviewPoster.layer.shadowOpacity = 0.8
        moviewPoster.layer.shadowOffset = CGSize(width: 0, height: 5)
        moviewPoster.layer.shadowRadius = 5
        contentView.isUserInteractionEnabled = false
    }
    
    func fill(with movieDetails: MovieDetailsResponse?) {
        guard let movieDetails = movieDetails else { return }
        if let posterPath = movieDetails.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviewPoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
        }
        if let logoPath = movieDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
            companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "placeholder"))
        }
        ganreName.text = "Genre: " + movieDetails.genres.map({ $0.name }).joined(separator: ", ")
        voteAverage.text = "Rate: \(movieDetails.voteAverage)"
        releaseDate.text = "Release Date: " + movieDetails.releaseDate
    }
}
