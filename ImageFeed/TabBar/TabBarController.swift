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
        
        // Setup imagelist vc
        let imagesListViewController = ImagesListViewController()
        let imagesListService = ImageListService()
        let imagesListPresenter = ImageListPresenter(imageListService: imagesListService)
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        // Setup profile vc
        let profileViewController = ProfileViewController()
        let profileService = ProfileService.shared
        let profileImageService = ProfileImageService.shared
        let profilePresenter = ProfileViewPresenter(profileService: profileService,
                                                    profileImageService: profileImageService)
        profilePresenter.view = profileViewController
        profileViewController.presenter = profilePresenter
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(named: "tab_profile_active"),
                                                        selectedImage: nil)
        profileViewController.tabBarItem.accessibilityIdentifier = "profileTabBarIdentifier"
        
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: UIImage(named: "tab_editorial_active"),
                                                           selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
