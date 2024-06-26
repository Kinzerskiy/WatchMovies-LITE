//
//  NavigationHeaderView.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

protocol NavigationHeaderViewDelegate: AnyObject {
    func leftButtonTapped()
    func rightButtonTapped()
    func actionButtonTapped()
}

class NavigationHeaderView: UICollectionViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    weak var delegate: NavigationHeaderViewDelegate?
    
    // MARK: - Memory management
    
    class func loadView() -> NavigationHeaderView {
        let view: NavigationHeaderView = Bundle.main.loadNibNamed(String(describing: NavigationHeaderView.self), owner: nil)?.first as! NavigationHeaderView
        
        return view
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 400)
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        titleName.font = UIFont.lotaBold(ofSize: 18)
        titleLabel.font = UIFont.lotaBold(ofSize: 30)
        titleLabel.textColor = .black
        titleName.numberOfLines = 2
        titleName.lineBreakMode = .byWordWrapping
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        backButton.tintColor = .black
        optionsButton.tintColor = .black
        actionButton.tintColor = .black
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        delegate?.leftButtonTapped()
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        delegate?.rightButtonTapped()
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        delegate?.actionButtonTapped()
    }
}
