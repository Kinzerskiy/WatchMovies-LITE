//
//  MainRouter.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation
import UIKit

protocol MainRouting: BaseRouting, DismissRouting, IntroViewControllerDelegate {
    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool)
    func showPersonForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool)
}

protocol MainRouterDelegate {
    func introRouterDidFinishLoading(router: MainRouter)
}

class MainRouter: BaseRouter, MainRouting {
    
    private var introViewController: IntroViewController?
    private var navigationController: UINavigationController?
    
    var mainDelegate: MainRouterDelegate?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    init(with navigationController: UINavigationController?, assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
        
        self.navigationController = navigationController
    }
    
    // MARK: - MovieListRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: IntroViewController = assembly.assemblyIntroViewController(with: self)
            introViewController = vc
            introViewController?.introDelegate = self
            
            navigationController = assembly.assemblyNavigationController(with: vc)
            navigationController?.isNavigationBarHidden = true
            navigationController?.modalPresentationStyle = .overFullScreen
            navigationController?.modalTransitionStyle = .crossDissolve
            
        }
        return navigationController!
    }
    
    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool) {
        let vc: DetailsViewController = assembly.assemblyDetailsViewController(with: self)
        
        vc.selectedId = id
        vc.isMovie = isMovie
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPersonForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool) {
        let vc: PersonViewController = assembly.assemblyPersonViewController(with: self)
        
        vc.pesonId = id
        vc.isMovie = isMovie
        viewController.present(vc, animated: animated, completion: nil)
    }
    
    
    func dissmiss(viewController: UIViewController, animated: Bool, completion: (() -> ())?) {
        let CompletionBlock: () -> Void = { () -> () in
            if let completion = completion {
                completion()
            }
        }
        
        if let insertedInNavigationStack = navigationController?.viewControllers.contains(viewController), !insertedInNavigationStack {
            viewController.dismiss(animated: animated, completion: completion)
            return
        }
        
        let isActiveInStack = self.navigationController?.viewControllers.last == viewController
        if !isActiveInStack {
            CompletionBlock()
            return
        }
        
        navigationController?.popViewController(animated: animated)
        
        return
    }
    
    // MARK: - IntroViewControllerDelegate
    
    func introControllerDidFinishLoading(viewController: IntroViewController) {
        mainDelegate?.introRouterDidFinishLoading(router: self)
    }
}
