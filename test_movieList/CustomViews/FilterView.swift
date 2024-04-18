//
//  FilterView.swift
//  test_movieList
//
//  Created by User on 18.04.2024.
//

import UIKit

protocol FilterViewDelegate: AnyObject {
    func searchTapped()
    func segment1()
    func segment2()
    func segment3()
    func segment4()
}

class FilterView: UIView {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    
    weak var delegate: FilterViewDelegate?
    
    // MARK: - Memory management
    
    class func loadView() -> FilterView {
        let view: FilterView = Bundle.main.loadNibNamed(String(describing: FilterView.self), owner: nil)?.first as! FilterView
        
        return view
    }
    
    
    func setSegmentTitles(titles: [String]) {
        for (index, title) in titles.enumerated() {
            segmentControl.setTitle(title, forSegmentAt: index)
        }
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        delegate?.searchTapped()
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
