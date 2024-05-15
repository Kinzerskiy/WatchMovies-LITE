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
    
    var router: MainRouting?
    var introDelegate: IntroViewControllerDelegate?
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var firstVideoView: UIView!
    @IBOutlet private weak var secondVideoView: UIView!
    @IBOutlet private weak var thirdVideoView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    private var currentPage: Int = 0
    private var players: [AVPlayer?]!
    private var currentPlayer: AVPlayer?
    
    // MARK: - View
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayers()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setupPlayers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        if let player = players[currentPage] {
            play(player: player, playerView: firstVideoView)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupPlayers() {
        
        players = [ setupPlayer(name: "OpenClassic"), setupPlayer(name: "OpenChristmas"), setupPlayer(name: "OpenOffice")]
    }
    
    private func setupView() {
        
        continueButton.isEnabled = true
        
        titleLabel.text =  "Welcome to WatchMovies!"
        subtitleLabel.text = "Movies & TVSeries Lists"
        continueButton.titleLabel?.text = "Continue"
    }
    
    private func setupPlayer(name: String) -> AVPlayer? {
        
        guard let dataAsset = NSDataAsset(name: name), let asset = AVURLAsset(dataAsset) else {
            return nil
        }
        
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        return player
    }
    
    private func play(player: AVPlayer, playerView: UIView) {
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer)
        player.play()
        
        currentPlayer = player
    }
    
    private func show(page: Int) {
        self.scrollView.contentOffset.x = CGFloat(page) * self.scrollView.frame.width
    }
    
    private func setupSecondView() -> UIView {
        
        titleLabel.text = "Add fils or tv series in watchlist!"
        subtitleLabel.text = "Make your own collection"
        
        return secondVideoView
    }
    
    private func setupThirdView() -> UIView {
        
        titleLabel.text = "Share your list with friends"
        subtitleLabel.text = "Make life better"
        
        return thirdVideoView
    }
    
    @objc func restartVideo() {
        currentPlayer?.pause()
        currentPlayer?.currentItem?.seek(to: CMTime.zero, completionHandler: { _ in
            self.currentPlayer?.play()
        })
    }
}

extension IntroViewController {
    
    @IBAction func continueButtonDidPressed(sender: UIButton) {
        
        currentPage = currentPage + 1
        
        if currentPage < players.count {
            show(page: currentPage)
            if let player = players[currentPage] {
                play(player: player, playerView: currentPage > 1 ? setupThirdView() : setupSecondView())
            }
        } else {
            self.introDelegate?.introControllerDidFinishLoading(viewController: self)
        }
    }
}
