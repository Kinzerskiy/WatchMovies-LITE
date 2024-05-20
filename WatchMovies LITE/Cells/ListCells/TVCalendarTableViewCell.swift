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
    @IBOutlet weak var tvSeriesDate: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func dateSelected(_ sender: Any) {
        
    }
}
