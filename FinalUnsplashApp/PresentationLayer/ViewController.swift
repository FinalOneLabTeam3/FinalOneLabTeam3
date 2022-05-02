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
        configureTabBar()
    }
    private func configureTabBar(){
        tabBar.backgroundColor = .systemGray5
        let feedVC = configureNavBarController(vc: SearchViewController(), image: "text.below.photo.fill")
        feedVC.title = "My Photos"
        self.setViewControllers([feedVC], animated: false)
    }
}


extension UITabBarController{
    func configureNavBarController(vc: UIViewController, image: String) -> UINavigationController{
    
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(systemName: image)
        return navController
        
    }
}





