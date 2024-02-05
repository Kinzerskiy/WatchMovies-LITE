//
//  ListRouter.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation
import UIKit

protocol ListRouting: BaseRouting, DismissRouting {
    func showMoviesDetailForm(with movie: MovieListResponse.MovieList?, viewController: UIViewController, animated: Bool)
}

class ListRouter: BaseRouter, ListRouting {
    
    var mainRouter: MainRouting?
    
    private var movieListViewController: MovieListViewController?
    private var navigationController: UINavigationController?
    
    // MARK: - Memory management
    
    override init(with assembly: NavigationAssemblyProtocol) {
        super.init(with: assembly)
    }
    
    // MARK: - ListRouting
    
    override func initialViewController() -> UIViewController {
        
        if navigationController == nil {
            let vc: MovieListViewController = assembly.assemblyMovieListViewController(with: self)
          
            let symbol = "popcorn.fill"
            let activeImage = UIImage(systemName: symbol)?.withTintColor(.orange, renderingMode: .alwaysOriginal)
            let inactiveImage = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
            vc.tabBarItem.title = "Movie List"
            vc.tabBarItem.image = inactiveImage
            vc.tabBarItem.selectedImage = activeImage
            
            movieListViewController = vc
            navigationController = assembly.assemblyNavigationController(with: vc)
            
            mainRouter = instantiateMainRouter()
        }
        return navigationController!
    }
    
    func showMoviesDetailForm(with movie: MovieListResponse.MovieList?, viewController: UIViewController, animated: Bool) {
        
        let vc: DetailsViewController = assembly.assemblyDetailsViewController(with: self)
        vc.selectedMovie = movie
        
        
        navigationController?.pushViewController(vc, animated: animated)
        
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

extension ListRouter {
    
    func instantiateMainRouter() -> MainRouter {
        let router = MainRouter.init(with: navigationController, assembly: assembly)
        
        return router
    }
}
