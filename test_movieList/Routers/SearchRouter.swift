//
//  SearchRouter.swift
//  test_movieList
//
//  Created by User on 24.04.2024.
//

import Foundation
import UIKit

protocol SearchRouting: BaseRouting, DismissRouting {
  
}

class SearchRouter: BaseRouter, SearchRouting {
    
    var mainRouter: MainRouting?
    
    private var searchViewController: SearchViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - MovieListRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: SearchViewController = assembly.assemblySearchViewController(with: self)
            
            let symbol = "sparkle.magnifyingglass"
            let activeImage = UIImage(systemName: symbol)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let inactiveImage = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
            vc.tabBarItem.title = "Search"
            vc.tabBarItem.image = inactiveImage
            vc.tabBarItem.selectedImage = activeImage
            
            searchViewController = vc
            navigationController = assembly.assemblyNavigationController(with: vc)
            
            mainRouter = instantiateMainRouter()
        }
        return navigationController!
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
}

extension SearchRouter {
    
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}
