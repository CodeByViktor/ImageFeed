//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Виктор on 17.07.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearence = UITabBarAppearance()
        appearence.backgroundColor = .ypBlack
        tabBar.standardAppearance = appearence
        tabBar.tintColor = .ypWhite
        
        let imagesListViewController = ImagesListViewController()
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "tab_editorial_active"),
                                                           selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
