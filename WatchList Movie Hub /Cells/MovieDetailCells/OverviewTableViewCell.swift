//
//  OverviewTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

class OverviewTableViewCell: UITableViewCell, DescribableCell {

    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overviewLabel.font = UIFont.lotaBold(ofSize: 18)
        overviewLabel.textColor = UIColor.orange
        overviewText.font = UIFont.lotaRegular(ofSize: 16)
        overviewText.isEditable = false
        overviewText.showsVerticalScrollIndicator = false
        overviewText.backgroundColor = .white
        overviewText.textColor = .black
    }
    
    func fill(with data: Any) {
        if let data = data as? MovieDetails {
            overviewText.text = data.overview
        } else if let data = data as? TVSeriesDetails {
            overviewText.text = data.overview
        }
    }
}
