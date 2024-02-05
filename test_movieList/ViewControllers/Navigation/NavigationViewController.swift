//
//  NavigationViewController.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

class NavigationController: UINavigationController {
    
    public var transitionDelegate: UINavigationControllerDelegate?
    
    // MARK: - View
    
    override func viewDidLoad() {        
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        delegate = self
    }
    
    
    // MARK: - Orientation
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask? {
        
        return topViewController?.supportedInterfaceOrientations
    }
    
    func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .portrait
    }
    
    func shouldAutorotate() -> Bool? {
        return topViewController?.shouldAutorotate
    }
}
