//
//  CardRouter.swift
//  WatchMovies LITE
//
//  Created by User on 09.05.2024.
//

import Foundation
import UIKit

protocol CardsRouting: BaseRouting, DismissRouting {
    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool)
}

class CardsRouter: BaseRouter, CardsRouting {
    
    var mainRouter: MainRouting?
    
    private var cardViewController: CardViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - FavoritesRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: CardViewController = assembly.assemblyCardViewController(with: self)
            
            let symbol = "rectangle.on.rectangle.circle"
            let activeImage = UIImage(systemName: symbol)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let inactiveImage = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
            vc.tabBarItem.title = "Let's roll"
            vc.tabBarItem.image = inactiveImage
            vc.tabBarItem.selectedImage = activeImage
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
            
            cardViewController = vc
            navigationController = assembly.assemblyNavigationController(with: vc)
            
            mainRouter = instantiateMainRouter()
        }
        
        return navigationController!
    }
    
    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool) {
        mainRouter?.showDetailForm(with: id, isMovie: isMovie, viewController: viewController, animated: true)
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

extension CardsRouter {
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}

