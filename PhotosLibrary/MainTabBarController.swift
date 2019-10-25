//
//  MainTabBarController.swift
//  PhotosLibrary
//
//  Created by Артем Улько on 09/10/2019.
//  Copyright © 2019 Артем Улько. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        let photosVC = PhotosCollectionViewCotroller(
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        viewControllers = [
            generateNavigationController(rootVewController: photosVC, title: "Photos", image: #imageLiteral(resourceName: "picture_2")),
            generateNavigationController(rootVewController: ViewController(), title:"Favourits", image:#imageLiteral(resourceName: "heart"))
        ]
    }
    
    private func generateNavigationController(rootVewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
    
}
