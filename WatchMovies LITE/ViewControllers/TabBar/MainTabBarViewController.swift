//
//  MainTabBarViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSeparatorLine()
        prepareUI()
    }
    
    func prepareUI() {
        UITabBarItem.appearance(whenContainedInInstancesOf: [MainTabBarViewController.self])
            .setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .selected)
    }
    
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    func setupSeparatorLine() {
        view.addSubview(separatorLine)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLine.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.3)
        ])
    }
}
