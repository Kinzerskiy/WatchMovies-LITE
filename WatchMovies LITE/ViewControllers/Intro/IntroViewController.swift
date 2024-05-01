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
    var playerLayer: AVPlayerLayer?
    
    var introDelegate: IntroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playIntroVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = introVideo.bounds
        playerLayer?.position = introVideo.center
        playerLayer?.videoGravity = .resizeAspectFill
    }
    
    private func playIntroVideo() {
          guard let videoURL = Bundle.main.path(forResource: "Movie", ofType: "mp4") else { return }
          
          let videoUrl = URL(fileURLWithPath: videoURL)
          self.player = AVPlayer(url: videoUrl)
          
          playerLayer = AVPlayerLayer(player: player)
          playerLayer?.videoGravity = .resizeAspectFill
          introVideo.layer.addSublayer(playerLayer!)
          
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
