//
//  ApplicationRouter.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import UIKit

enum ApplicationStoryType {
    case main
    case movieList
    case tvSeriesList
    case favorites
}

protocol ApplicationRouting: BaseRouting {
    func showIntroForm(from viewController: UIViewController?, animated: Bool, completion: RoutingCompletionBlock?)
}

class ApplicationRouter: ApplicationRouting, MainRouterDelegate {
    
    private var applicationAssembly: ApplicationAssemblyProtocol
    
    private var rootContentController: UITabBarController?
    
    private var activeStoryType: ApplicationStoryType?
    private var previousStoryType: ApplicationStoryType?
    
    private var mainRouter: MainRouter?
    private var movieListRouter: MovieListRouter?
    private var tvSeriesListRouter: TVSeriesListRouter?
    private var favoritesRouter: FavoritesRouter?
    
    // MARK: - Memory management
    
    required init(with assembly: ApplicationAssemblyProtocol) {
        applicationAssembly = assembly
        
        setupRouters()
    }
    
    private func setupRouters() {
        mainRouter = assemblyMainRouter()
        movieListRouter = assemblyMovieListRouter()
        tvSeriesListRouter = assemblyTVSeriesListRouter()
        favoritesRouter = assemblyFavoritesRouter()
    }
    
    // MARK: - BaseRouting
    
    func initialViewController() -> UIViewController? {
        
        let rootItem: Array<UIViewController> = [
            intialialViewControllerForItem(with: .movieList),
            intialialViewControllerForItem(with: .tvSeriesList),
            intialialViewControllerForItem(with: .favorites)
            
        ]
        
        rootContentController = navigationAssembly().assemblyTabbarController(with: rootItem)
        
        return rootContentController
    }
    
    // MARK: - ApplicationRouting
    
    func showIntroForm(from viewController: UIViewController?, animated: Bool, completion: RoutingCompletionBlock?) {
        rootContentController?.present((mainRouter?.initialViewController())!, animated: animated, completion: completion)
    }
    
    // MARK: - AuthRouterDelegate
    
    func introRouterDidFinishLoading(router: MainRouter) {
        Defaults.firstInitialization = false
        router.initialViewController().dismiss(animated: false)
        
        switchToStory(with: .movieList)
    }
    
    // MARK: - Assembly
    
    func navigationAssembly() -> NavigationAssemblyProtocol {
        return applicationAssembly.sharedNavigationAssembly
    }
    
    func assemblyMainRouter() -> MainRouter {
        let router = MainRouter(with: navigationAssembly())
        router.mainDelegate = self
        
        return router
    }
    
    func assemblyMovieListRouter() -> MovieListRouter {
        let router = MovieListRouter(with: navigationAssembly())
        
        return router
    }
    
    func assemblyFavoritesRouter() -> FavoritesRouter {
        let router = FavoritesRouter(with: navigationAssembly())
        
        return router
    }
    
    func assemblyTVSeriesListRouter() -> TVSeriesListRouter {
        let router = TVSeriesListRouter(with: navigationAssembly())
        
        return router
    }
    
    // MARK: - Private
    
    private func switchToStory(with type: ApplicationStoryType) {
        rootContentController?.selectedViewController = intialialViewControllerForItem(with: type)
        
        if activeStoryType != type {
            previousStoryType = activeStoryType
        }
        
        activeStoryType = type
    }
    
    private func intialialViewControllerForItem(with type: ApplicationStoryType) -> UIViewController {
        
        switch type {
        case .movieList:
            return (movieListRouter?.initialViewController())!
        case .favorites:
            return (favoritesRouter?.initialViewController())!
        case .main:
            return (mainRouter?.initialViewController())!
        case .tvSeriesList:
            return (tvSeriesListRouter?.initialViewController())!
        }
    }
}
