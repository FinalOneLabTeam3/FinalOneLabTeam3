//
//  TabBarController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import UIKit

class TabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabBar()
    }

    
    private func configureTabBar() {
        let feedVC = configureNavBarController(vc: DiscoverViewController(viewModel: DiscoverViewModel(dataFetch: NetworkDataFetch.shared)), image: "magnifyingglass")
        let homeVC = configureNavBarController(vc: HomeViewController(viewModel: HomeViewModel(networkDataFetch: NetworkDataFetch.shared)), image: "photo")
        self.setViewControllers([homeVC, feedVC], animated: false)
        
    }
}


extension UITabBarController{
    func configureNavBarController(vc: UIViewController, image: String) -> UINavigationController{
    
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
        
    }
}





