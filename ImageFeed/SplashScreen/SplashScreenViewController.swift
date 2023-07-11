//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage().token {
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navController = segue.destination as? UINavigationController,
                  let viewController = navController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        //dismiss(animated: true) { [weak self] in
            //guard let self = self else { return }
        UIBlockingProgressHUD.show()
        self.fetchOAuthToken(code)
        //}
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.dismiss(animated: true) {
                    self.profileImageService.fetchProfileImageURL(username: profile.username!) { _ in }
                    UIBlockingProgressHUD.hide()
                    self.switchToTabBarController()
                }
                break
            case .failure(let error):
                break
            }
        }
    }
}
