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
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var bookMark: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var favorite: Favorites?
    var data: MediaId?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    func prepareUI() {
        moviePoster.clipsToBounds = true
        if let placeholderImageName = moviePoster.image?.accessibilityIdentifier, placeholderImageName == "Popcorn" {
            moviePoster.contentMode = .scaleAspectFit
        } else {
            moviePoster.contentMode = .scaleAspectFit
        }
        moviePoster.layer.shadowColor = UIColor.black.cgColor
        moviePoster.layer.shadowOpacity = 0.8
        moviePoster.layer.shadowOffset = CGSize(width: 0, height: 5)
        moviePoster.layer.shadowRadius = 5
        contentView.isUserInteractionEnabled = true
        bookMark.tintColor = .orange
        bookMark.isSelected = false
        
        shareButton.tintColor = .orange
        shareButton.isSelected = false
        
        bookMark.setImage(UIImage(systemName: "bookmark"), for: .normal)
        shareButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        guard let data = data else { return }
        
        if let favorite = FavoritesManager.shared.fetchFavoriteMedia(for: data) {
            FavoritesManager.shared.deleteFavorite(favorite: favorite)
            bookMark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            shareButton.isHidden = false
        } else {
            FavoritesManager.shared.saveToWatchlist(data: data, watchlistType: .hasWatched)
            bookMark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            shareButton.isHidden = true
        }
    }
    
    @IBAction func hasWatchedDidTapped(_ sender: UIButton) {
        guard let data = data else { return }
        
        if let favorite = FavoritesManager.shared.fetchFavoriteMedia(for: data) {
            FavoritesManager.shared.deleteFavorite(favorite: favorite)
            shareButton.setImage(UIImage(systemName: "eye"), for: .normal)
            bookMark.isHidden = false
        } else {
            FavoritesManager.shared.saveToWatchlist(data: data, watchlistType: .toWatch)
            shareButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            bookMark.isHidden = true
        }
    }
    
    func fill(with data: Any) {
        if let movieDetails = data as? MovieDetails {
            self.data = movieDetails
            
            if let posterPath = movieDetails.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let orangeTextColor = UIColor.orange
            let blackColor = UIColor.black
            
            let font = UIFont.lotaBold(ofSize: 14)
            let orangeAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: orangeTextColor]
            let blackAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: blackColor]
            
            let genreText = NSMutableAttributedString(string: "Genres: ", attributes: orangeAttributes)
            let genres = movieDetails.genres.map({ $0.name }).joined(separator: ", ")
            let genresText = NSAttributedString(string: genres, attributes: blackAttributes)
            genreText.append(genresText)
            genreName.attributedText = genreText
            
            let rateText = NSMutableAttributedString(string: "Rate: ", attributes: orangeAttributes)
            let rateValue = NSAttributedString(string: "\(movieDetails.voteAverage)", attributes: blackAttributes)
            rateText.append(rateValue)
            voteAverage.attributedText = rateText
            
            if let logoPath = movieDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
                companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let releaseDateText = NSMutableAttributedString(string: "Release Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: movieDetails.releaseDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
            
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            self.data = tvSeriesDetails
            
            if let posterPath = tvSeriesDetails.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let orangeTextColor = UIColor.orange
            let blackColor = UIColor.black
            
            let font = UIFont.lotaBold(ofSize: 14)
            let orangeAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: orangeTextColor]
            let blackAttributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: blackColor]
            
            let genreText = NSMutableAttributedString(string: "Genres: ", attributes: orangeAttributes)
            let genres = tvSeriesDetails.genres.map({ $0.name }).joined(separator: ", ")
            let genresText = NSAttributedString(string: genres, attributes: blackAttributes)
            genreText.append(genresText)
            genreName.attributedText = genreText
            
            let rateText = NSMutableAttributedString(string: "Rate: ", attributes: orangeAttributes)
            let rateValue = NSAttributedString(string: "\(tvSeriesDetails.voteAverage)", attributes: blackAttributes)
            rateText.append(rateValue)
            voteAverage.attributedText = rateText
            
            if let logoPath = tvSeriesDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
                companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let releaseDateText = NSMutableAttributedString(string: "First Air Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: tvSeriesDetails.firstAirDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
        }
        
        guard let favorite = FavoritesManager.shared.fetchFavoriteMedia(for: data as! MediaId) else {
            bookMark.isHidden = false
            shareButton.isHidden = false
            return
        }
        
        if !favorite.isWatchingType {
            shareButton.isHidden = true
            bookMark.isHidden = false
            bookMark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookMark.isHidden = true
            shareButton.isHidden = false
            shareButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
}
