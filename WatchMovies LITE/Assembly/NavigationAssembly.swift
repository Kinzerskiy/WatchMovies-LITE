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
    func assemblyDetailsViewController(with router: MainRouting) -> DetailsViewController
    func assemblyPersonViewController(with router: MainRouting) -> PersonViewController
}

protocol MovieListNavigationAssemblyProtocol {
    func assemblyMovieListViewController(with router: MovieListRouting) -> MovieListViewController
}

protocol TVSeriesListNavigationAssemblyProtocol {
    func assemblyTVSeriesListViewController(with router: TVSeriesListRouting) -> TVSeriesViewController
}

protocol SearchNavigationAssemblyProtocol {
    func assemblySearchViewController(with router: SearchRouting) -> SearchViewController
    func assemblySearchResultViewController(with router: SearchRouting) -> SearchResultViewController
}

protocol FavoritesNavigationAssemblyProtocol {
    func assemblyFavoriteMoviesViewController(with router: FavoritesRouting) -> FavoriteMoviesViewController
}

protocol CardNavigationAssemblyProtocol {
    func assemblyCardViewController(with router: CardsRouting) -> CardViewController
}

protocol NavigationAssemblyProtocol: CommonNavigationAssemblyProtocol,
                                     MainNavigationAssemblyProtocol,
                                     MovieListNavigationAssemblyProtocol,
                                     FavoritesNavigationAssemblyProtocol,
                                     TVSeriesListNavigationAssemblyProtocol,
                                     SearchNavigationAssemblyProtocol,
                                     CardNavigationAssemblyProtocol
{
    
}

class NavigationAssembly: BaseAssembly, NavigationAssemblyProtocol {
   
    private static let mainStoryboardName = "Main"
    private static let movieListStoryboardName = "MovieList"
    private static let tvSeriesListStoryboardName = "TVSeriesList"
    private static let favoritesStoryboardName = "Favorites"
    private static let searchStoryboardName = "Search"
    private static let cardsStoryboardName = "Cards"

    // MARK: - Storyboard
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.mainStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func movieListStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.movieListStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func tvSeriesListStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.tvSeriesListStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func favoritesStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.favoritesStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func searchStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.searchStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
    }
    
    func cardsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: NavigationAssembly.cardsStoryboardName, bundle: Bundle(for: NavigationAssembly.self))
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
    
    func assemblyDetailsViewController(with router: MainRouting) -> DetailsViewController {
        let vc: DetailsViewController = mainStoryboard().instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        vc.router = router
        
        return vc
    }
    func assemblyPersonViewController(with router: MainRouting) -> PersonViewController {
        let vc: PersonViewController = mainStoryboard().instantiateViewController(withIdentifier: String(describing: PersonViewController.self)) as! PersonViewController
        vc.router = router
        
        return vc
    }
    
    
    // MARK: MovieList
    
    func assemblyMovieListViewController(with router: MovieListRouting) -> MovieListViewController {
        let vc: MovieListViewController = movieListStoryboard().instantiateViewController(withIdentifier: String(describing: MovieListViewController.self)) as! MovieListViewController
        vc.router = router
        
        return vc
    }
    
    
    // MARK: TVSeries
    
    func assemblyTVSeriesListViewController(with router: TVSeriesListRouting) -> TVSeriesViewController {
        let vc: TVSeriesViewController = tvSeriesListStoryboard().instantiateViewController(withIdentifier: String(describing: TVSeriesViewController.self)) as! TVSeriesViewController
        vc.router = router
        
        return vc
    }
    
    // MARK: Search
    
    func assemblySearchViewController(with router: SearchRouting) -> SearchViewController {
        let vc: SearchViewController = searchStoryboard().instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as! SearchViewController
        vc.router = router
        
        return vc
    }
    
    func assemblySearchResultViewController(with router: SearchRouting) -> SearchResultViewController {
        let vc: SearchResultViewController = searchStoryboard().instantiateViewController(withIdentifier: String(describing: SearchResultViewController.self)) as! SearchResultViewController
        vc.router = router
        
        return vc
    }
    
    // MARK: Favorites
    
    func assemblyFavoriteMoviesViewController(with router: FavoritesRouting) -> FavoriteMoviesViewController {
        let vc: FavoriteMoviesViewController = favoritesStoryboard().instantiateViewController(withIdentifier: String(describing: FavoriteMoviesViewController.self)) as! FavoriteMoviesViewController
        vc.router = router
        
        return vc
    }
    
    // MARK: Cards
    
    func assemblyCardViewController(with router: CardsRouting) -> CardViewController {
        let vc: CardViewController = cardsStoryboard().instantiateViewController(withIdentifier: String(describing: CardViewController.self)) as! CardViewController
        vc.router = router
        
        return vc
    }
    
    
}
