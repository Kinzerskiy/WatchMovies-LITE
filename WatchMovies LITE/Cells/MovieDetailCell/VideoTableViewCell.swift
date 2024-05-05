//
//  VideoTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 05.05.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.clipsToBounds = true
        playerView.layer.borderWidth = 1.0
        playerView.layer.borderColor = UIColor.orange.cgColor
        playerView.layer.shadowColor = UIColor.orange.cgColor
        playerView.layer.shadowOpacity = 0.5
        playerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        playerView.layer.shadowRadius = 2
        playerView.layer.masksToBounds = false
    }
    
    func fill(with videoId: String) {
        if let ytPlayerView = playerView {
            ytPlayerView.load(withVideoId: videoId)
        }
    }
}
