//
//  DoubleTapViewController.swift
//  WatchMovies LITE
//
//  Created by User on 02.05.2024.
//

import UIKit

class DoubleTapViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var doubleTapImage: UIImageView!
    @IBOutlet weak var doubleTapLabel: UILabel!
    @IBOutlet weak var doubleTapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    func prepareUI() {
        self.view.backgroundColor = .clear
        contentView.backgroundColor = .clear
        doubleTapLabel.text = "Double tap to add in favorites"
        doubleTapLabel.layer.backgroundColor = UIColor.black.cgColor
        doubleTapLabel.layer.cornerRadius = 10
        doubleTapButton.titleLabel?.font = UIFont.lotaBold(ofSize: 20)
    }

    
    @IBAction func okButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
