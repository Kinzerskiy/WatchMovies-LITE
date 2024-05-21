//
//  TVCalendarTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 20.05.2024.
//

import UIKit


class TVCalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var tvSeriesTitle: UILabel!
    
    func fill(with tvSeries: TVSeriesDetails) {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let posterURL = URL(string: baseURL + (tvSeries.posterPath ?? ""))
        posterImage.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "Popcorn"))
        
        tvSeriesTitle.text = tvSeries.title
    }
    
}
