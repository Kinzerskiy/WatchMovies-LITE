//
//  IntroViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit
import AVKit
import AVFoundation

protocol IntroViewControllerDelegate {
    func introControllerDidFinishLoading(viewController: IntroViewController)
}

class IntroViewController: UIViewController {
    
    @IBOutlet weak var introVideo: UIView!
    var player: AVPlayer?
    
    var introDelegate: IntroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playIntroVideo()
    }
    
    private func playIntroVideo() {
        
        guard let videoURL = Bundle.main.path(forResource: "Movie", ofType: "mp4") else { return }
        
        let videoUrl = URL(fileURLWithPath: videoURL)
        self.player = AVPlayer(url: videoUrl)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = introVideo.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        introVideo.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        self.player?.play()
    }
    
    
    @objc private func playerDidFinishPlaying() {
        introDelegate?.introControllerDidFinishLoading(viewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
