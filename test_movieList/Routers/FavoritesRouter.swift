//
//  FavoritesRouter.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation
import UIKit

protocol FavoritesRouting: BaseRouting, DismissRouting {
    func showDetailForm(with id: Int, isMovie: Bool, viewController: UIViewController, animated: Bool)
}

class FavoritesRouter: BaseRouter, FavoritesRouting {
    
    var mainRouter: MainRouting?
    var listRouter: MovieListRouting?
    
    private var favoritesMoviesViewController: FavoriteMoviesViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - FavoritesRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: FavoriteMoviesViewController = assembly.assemblyFavoriteMoviesViewController(with: self)
            
            let symbol = "heart.circle.fill"
            let activeImage = UIImage(systemName: symbol)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let inactiveImage = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
            vc.tabBarItem.title = "Favorites"
            vc.tabBarItem.image = inactiveImage
            vc.tabBarItem.selectedImage = activeImage
            
            favoritesMoviesViewController = vc
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

extension FavoritesRouter {
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}

