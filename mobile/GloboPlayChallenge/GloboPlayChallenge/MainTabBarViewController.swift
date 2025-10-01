//
//  ViewController.swift
//  GloboPlayChallenge
//
//  Created by ana on 01/10/25.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        
        let vc1 = UINavigationController(rootViewController: MovieListViewController())
        let vc2 = UINavigationController(rootViewController: FavoriteViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "heart.rectangle.fill")
        
        vc1.title = "Início"
        vc2.title = "Favoritos"
        
        tabBar.tintColor = .label
        
        setViewControllers( [vc1, vc2], animated: false)
        
        
    }


}

