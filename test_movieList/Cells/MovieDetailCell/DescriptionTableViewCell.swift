//
//  DescriptionTableViewCell.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import SDWebImage

protocol DescribableCell {
    associatedtype DataType
    func fill(with data: DataType)
}

class DescriptionTableViewCell: UITableViewCell, DescribableCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var ganreName: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var bookMark: UIButton!
    
    var bookmarkActionHandler: (() -> Void)?
    
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
        contentView.isUserInteractionEnabled = true
        
        bookMark.tintColor = .orange
        bookMark.isSelected = false
    }
    
    
    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        bookmarkActionHandler?()
        print("Bookmark button tapped")
        sender.isSelected.toggle()
        
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }

    
    func fill(with data: MediaDetails) {
        if let posterPath = data.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"))
        }

        let orangeTextColor = UIColor.orange
        let blackColor = UIColor.black

        let font = UIFont.lotaBold(ofSize: 14)
        let orangeAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: orangeTextColor]
        let blackAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: blackColor]

        let genreText = NSMutableAttributedString(string: "Genres: ", attributes: orangeAttributes)
        let genres = data.genres.map({ $0.name }).joined(separator: ", ")
        let genresText = NSAttributedString(string: genres, attributes: blackAttributes)
        genreText.append(genresText)
        ganreName.attributedText = genreText

        let rateText = NSMutableAttributedString(string: "Rate: ", attributes: orangeAttributes)
        let rateValue = NSAttributedString(string: "\(data.voteAverage)", attributes: blackAttributes)
        rateText.append(rateValue)
        voteAverage.attributedText = rateText

        if let movieDetails = data as? MovieDetails {
            let releaseDateText = NSMutableAttributedString(string: "Release Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: movieDetails.releaseDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            let releaseDateText = NSMutableAttributedString(string: "First Air Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: tvSeriesDetails.firstAirDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
        }
    }
}
