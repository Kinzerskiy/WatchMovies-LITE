//
//  OverviewTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overviewLabel.font = UIFont.lotaBold(ofSize: 18)
        overviewLabel.textColor = UIColor.orange
        overviewText.font = UIFont.lotaRegular(ofSize: 16)
        overviewText.isEditable = false
        overviewText.showsVerticalScrollIndicator = false
    }
    
    func fill(with movieDetails: MovieDetailsResponse?) {
        guard let movieDetails = movieDetails else { return }
        overviewText.text = movieDetails.overview
    }
}
