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
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.isHidden = true
        thumbnailImageView.isHidden = false
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
        thumbnailImageView.isHidden = false
        playerView.isHidden = true
        thumbnailImageView.image = UIImage(named: "youTube")
        playerView.load(withVideoId: videoId)
    }
}

extension VideoTableViewCell: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        thumbnailImageView.isHidden = true
        playerView.isHidden = false
    }
}
