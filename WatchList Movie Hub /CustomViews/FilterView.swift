//
//  FilterView.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func segment1()
    func segment2()
    func segment3()
    func segment4()
}

class FilterView: UIView {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    weak var delegate: FilterViewDelegate?
    
    // MARK: - Memory management
    
    class func loadView() -> FilterView {
        let view: FilterView = Bundle.main.loadNibNamed(String(describing: FilterView.self), owner: nil)?.first as! FilterView
        return view
    }
    
    func setupView() {
        segmentControl.layer.cornerRadius = segmentControl.bounds.height / 3
        segmentControl.clipsToBounds = true
        segmentControl.layer.shadowColor = UIColor.black.cgColor
        segmentControl.layer.shadowOffset = CGSize(width: 0, height: 2)
        segmentControl.layer.shadowRadius = 4
        segmentControl.layer.shadowOpacity = 0.4
        segmentControl.layer.masksToBounds = false
        segmentControl.backgroundColor = UIColor.white
        segmentControl.tintColor = UIColor.clear
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func setSegmentTitles(titles: [String], font: UIFont, color: UIColor) {
        segmentControl.removeAllSegments()
        for title in titles {
            segmentControl.insertSegment(withTitle: title, at: segmentControl.numberOfSegments, animated: false)
        }
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        segmentControl.setTitleTextAttributes(attributes, for: .normal)
        segmentControl.selectedSegmentIndex = 0
    }
    
    
    @IBAction func segmentTapped(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            delegate?.segment1()
        case 1:
            delegate?.segment2()
        case 2:
            delegate?.segment3()
        case 3:
            delegate?.segment4()
        default:
            break
        }
    }
}
