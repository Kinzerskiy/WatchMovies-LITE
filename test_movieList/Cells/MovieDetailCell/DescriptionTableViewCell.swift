//
//  DescriptionTableViewCell.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import SDWebImage

class DescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var ganreName: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    func prepareUI() {
        moviePoster.clipsToBounds = true
        moviePoster.contentMode = .scaleAspectFit
        moviePoster.layer.shadowColor = UIColor.black.cgColor
        moviePoster.layer.shadowOpacity = 0.8
        moviePoster.layer.shadowOffset = CGSize(width: 0, height: 5)
        moviePoster.layer.shadowRadius = 5
        contentView.isUserInteractionEnabled = false
        
    }
    
    func fill(with movieDetails: MovieDetailsResponse?) {
        guard let movieDetails = movieDetails else { return }
        if let posterPath = movieDetails.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
        }
        if let logoPath = movieDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
            companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "placeholder"))
        }
        
        let orangeTextColor = UIColor.orange
        let blackColor = UIColor.black
        
        let font = UIFont.lotaBold(ofSize: 14) 
        let orangeAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: orangeTextColor]
        let blackAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: blackColor]
        
        let genreText = NSMutableAttributedString(string: "Genre: ", attributes: orangeAttributes)
        let genres = movieDetails.genres.map({ $0.name }).joined(separator: ", ")
        let genresText = NSAttributedString(string: genres, attributes: blackAttributes)
        genreText.append(genresText)
        ganreName.attributedText = genreText

        let rateText = NSMutableAttributedString(string: "Rate: ", attributes: orangeAttributes)
        let rateValue = NSAttributedString(string: "\(movieDetails.voteAverage)", attributes: blackAttributes)
        rateText.append(rateValue)
        voteAverage.attributedText = rateText

        let releaseDateText = NSMutableAttributedString(string: "Release Date: ", attributes: orangeAttributes)
        let releaseDateValue = NSAttributedString(string: movieDetails.releaseDate, attributes: blackAttributes)
        releaseDateText.append(releaseDateValue)
        releaseDate.attributedText = releaseDateText
    }

}
