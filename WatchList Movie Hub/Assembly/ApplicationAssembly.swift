//
//  ApplicationAssembly.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

protocol ApplicationAssemblyProtocol {
    var sharedNavigationAssembly: NavigationAssemblyProtocol { get }
}

class ApplicationAssembly: BaseAssembly, ApplicationAssemblyProtocol {
    
    private var navigationAssembly: NavigationAssemblyProtocol
    
    static func defaultAssembly() -> ApplicationAssembly {
       
        let navigationAssembly = NavigationAssembly()
        
        return self.init(with: navigationAssembly)
    }
    
    required init(with navigationAssembly: NavigationAssemblyProtocol) {
        
        self.navigationAssembly = navigationAssembly
    }
    
    // MARK: - Public
    
    func assemblyApplicationRouter() -> ApplicationRouting {
        return ApplicationRouter(with: self)
    }
    
    // MARK: - ApplicationAssemblyProtocol
    
    var sharedNavigationAssembly: NavigationAssemblyProtocol {
        return navigationAssembly
    }
}
