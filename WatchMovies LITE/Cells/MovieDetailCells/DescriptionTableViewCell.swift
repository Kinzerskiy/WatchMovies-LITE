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
    var data: MediaDetails?
    
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
    }
    
    func updateFavoriteStatus(isFavorite: Bool) {
        bookMark.isSelected = isFavorite
        bookMark.setImage(isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let data = data else { return }
        
        if let existingFavorite = FavoritesManager.shared.fetchFavoriteMedia(for: data) {
            FavoritesManager.shared.deleteFavorite(favorite: existingFavorite)
        } else {
            FavoritesManager.shared.saveToFavorites(data: data)
        }
        updateFavoriteStatus(isFavorite: sender.isSelected)
    }
    
    @IBAction func shareAction(_ sender: Any) {
        guard let posterImage = moviePoster.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [posterImage], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self
            popoverController.sourceRect = self.bounds
        }
        if let viewController = self.parentViewController {
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func fill(with data: MediaDetails) {
        self.data = data
        
        if let posterPath = data.posterPath, let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            moviePoster.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
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
        genreName.attributedText = genreText
        
        let rateText = NSMutableAttributedString(string: "Rate: ", attributes: orangeAttributes)
        let rateValue = NSAttributedString(string: "\(data.voteAverage)", attributes: blackAttributes)
        rateText.append(rateValue)
        voteAverage.attributedText = rateText
        
        if let movieDetails = data as? MovieDetails {
            if let logoPath = movieDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
                companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let releaseDateText = NSMutableAttributedString(string: "Release Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: movieDetails.releaseDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
            
            if let favorite = favorite, favorite.mediaId == Int64(movieDetails.id) {
                bookMark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                bookMark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            if let logoPath = tvSeriesDetails.productionCompanies.first?.logoPath, let logoURL = URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)") {
                companyLogo.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "Popcorn"))
            }
            
            let releaseDateText = NSMutableAttributedString(string: "First Air Date: ", attributes: orangeAttributes)
            let releaseDateValue = NSAttributedString(string: tvSeriesDetails.firstAirDate ?? "", attributes: blackAttributes)
            releaseDateText.append(releaseDateValue)
            releaseDate.attributedText = releaseDateText
            
            if let favorite = favorite, favorite.mediaId == Int64(tvSeriesDetails.id) {
                bookMark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                bookMark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
}
