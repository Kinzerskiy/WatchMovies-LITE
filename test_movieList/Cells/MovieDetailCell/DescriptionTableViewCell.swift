//
//  DescriptionTableViewCell.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import SDWebImage
import CoreData

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
    }
    
    func updateFavoriteStatus(isFavorite: Bool) {
        bookMark.isSelected = isFavorite
        bookMark.setImage(isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    private func saveToFavorites(in context: NSManagedObjectContext) {
        guard let data = data else { return }
        let favorite = Favorites(context: context)
        
        if let movieDetails = data as? MovieDetails {
            favorite.posterPath = movieDetails.posterPath
            favorite.mediaId = Int64(movieDetails.id)
            favorite.title = movieDetails.title
            favorite.isMovie = true
            favorite.isFavorite = true
        } else if let tvSeriesDetails = data as? TVSeriesDetails {
            favorite.posterPath = tvSeriesDetails.posterPath
            favorite.mediaId = Int64(tvSeriesDetails.id)
            favorite.title = tvSeriesDetails.name
            favorite.isMovie = false
            favorite.isFavorite = true
        }
        CoreDataManager.shared.saveContext()
    }


   
    func fetchFavoriteMedia(for data: MediaDetails, in context: NSManagedObjectContext) -> Favorites? {
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        request.predicate = NSPredicate(format: "mediaId == %ld", data.id)
        request.fetchLimit = 1

        do {
            let favorites = try context.fetch(request)
            return favorites.first
        } catch {
            print("Error fetching favorite movie: \(error)")
            return nil
        }
    }

    
    @IBAction func bookmarkDidTap(_ sender: UIButton) {
        bookmarkActionHandler?()
          print("Bookmark button tapped")
          sender.isSelected.toggle()
        
     
        if let existingFavorite = fetchFavoriteMedia(for: data!, in: CoreDataManager.shared.context) {
            CoreDataManager.shared.context.delete(existingFavorite)
            } else {
                saveToFavorites(in: CoreDataManager.shared.context)
            }
            
            CoreDataManager.shared.saveContext()
            
            if sender.isSelected {
                sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
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
        ganreName.attributedText = genreText
        
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
            
            // Check if the movie is in favorites and update the bookmark button
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
            
            // Check if the TV series is in favorites and update the bookmark button
            if let favorite = favorite, favorite.mediaId == Int64(tvSeriesDetails.id) {
                bookMark.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                bookMark.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }

}
