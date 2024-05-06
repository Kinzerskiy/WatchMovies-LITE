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
}

class NavigationHeaderView: UICollectionViewCell {

    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    
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
        titleName.numberOfLines = 2
        titleName.lineBreakMode = .byWordWrapping
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        backButton.tintColor = .orange
        
        optionsButton.tintColor = .orange
    }
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        delegate?.leftButtonTapped()
    }
    
    @IBAction func rightButtonTapped(_ sender: Any) {
        delegate?.rightButtonTapped()
    }
    
}
