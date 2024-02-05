//
//  NavigationAssembly.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

protocol CommonNavigationAssemblyProtocol {
    func assemblyTabbarController(with items: Array<UIViewController>) -> UITabBarController
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController
}

protocol MainNavigationAssemblyProtocol {
    func assemblyIntroViewController(with router: MainRouting) -> IntroViewController
}

protocol ListNavigationAssemblyProtocol {
    func assemblyMovieListViewController(with router: ListRouting) -> MovieListViewController
    func assemblyDetailsViewController(with router: ListRouting) -> DetailsViewController
}

protocol FavoritesNavigationAssemblyProtocol {
    func assemblyFavoriteMoviesViewController(with router: FavoritesRouting) -> FavoriteMoviesViewController
    func assemblyFavoriteDetailsViewController(with router: FavoritesRouting) -> FavoriteDetailsViewController
}

protocol NavigationAssemblyProtocol: CommonNavigationAssemblyProtocol,
                                     MainNavigationAssemblyProtocol,
                                     ListNavigationAssemblyProtocol,
                                     FavoritesNavigationAssemblyProtocol {
    
}

class NavigationAssembly: BaseAssembly, NavigationAssemblyProtocol {

    private static let mainStoryboardName = "Main"
    private static let listStoryboardName = "List"
    private static let favoritesStoryboardName = "Favorites"
    
    // MARK: - Storyboard
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.mainStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func listStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.listStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func favoritesStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.favoritesStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    // MARK: Common
    
    func assemblyTabbarController(with items: Array<UIViewController>) -> UITabBarController {
        let controller = mainStoryboard().instantiateViewController(withIdentifier: String(describing: MainTabBarViewController.self)) as! MainTabBarViewController
        controller.viewControllers = items
        
        return controller
    }
    
    func assemblyNavigationController(with item: UIViewController) -> UINavigationController {
        
        return NavigationController(rootViewController: item)
    }
    
    func assemblyAlertController(with title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: Main
    
    func assemblyIntroViewController(with router: MainRouting) -> IntroViewController {
        let vc: IntroViewController = mainStoryboard().instantiateViewController(withIdentifier: String(describing: IntroViewController.self)) as! IntroViewController
        
        return vc
    }
    
    // MARK: List
    
    func assemblyMovieListViewController(with router: ListRouting) -> MovieListViewController {
        let vc: MovieListViewController = listStoryboard().instantiateViewController(withIdentifier: String(describing: MovieListViewController.self)) as! MovieListViewController
        vc.router = router
        
        return vc
    }
    
    func assemblyDetailsViewController(with router: ListRouting) -> DetailsViewController {
        let vc: DetailsViewController = listStoryboard().instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        vc.router = router
        
        return vc
    }

    // MARK: Favorites
    
    func assemblyFavoriteMoviesViewController(with router: FavoritesRouting) -> FavoriteMoviesViewController {
        let vc: FavoriteMoviesViewController = favoritesStoryboard().instantiateViewController(withIdentifier: String(describing: FavoriteMoviesViewController.self)) as! FavoriteMoviesViewController
        vc.router = router
        
        return vc
    }
    
    
    func assemblyFavoriteDetailsViewController(with router: FavoritesRouting) -> FavoriteDetailsViewController {
        let vc: FavoriteDetailsViewController = favoritesStoryboard().instantiateViewController(withIdentifier: String(describing: FavoriteDetailsViewController.self)) as! FavoriteDetailsViewController
        vc.router = router
        
        return vc
    }
}
