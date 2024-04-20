//
//  OverviewTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overviewText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func fill(with movieDetails: MovieDetailsResponse?) {
        guard let movieDetails = movieDetails else { return }
        overviewText.text = movieDetails.overview
    }
}
