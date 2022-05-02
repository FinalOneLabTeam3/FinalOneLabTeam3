//
//  ViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTabBar()
        removeTabBarTransparency()
    }
    private func configureTabBar() {
        let feedVC = configureNavBarController(vc: SearchViewController(), image: "text.below.photo.fill")
        let homeVC = configureNavBarController(vc: HomeViewController(viewModel: HomeViewModel(networkDataFetch: NetworkDataFetch())), image: "photo")
        feedVC.title = "My Photos"
        self.setViewControllers([homeVC, feedVC], animated: false)
    }
    private func removeTabBarTransparency() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
}


extension UITabBarController{
    func configureNavBarController(vc: UIViewController, image: String) -> UINavigationController{
    
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
        
    }
}





