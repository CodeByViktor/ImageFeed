//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import UIKit

final class SplashScreenViewController: BaseViewController {
    // MARK: UI el
    private let logoImageView = {
        let logoView = UIImageView(image: UIImage(named: "Vector"))
        return logoView
    }()
    // ---
    
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
        } else {
            let authController = AuthViewController()
            authController.delegate = self
            authController.modalPresentationStyle = .fullScreen
            present(authController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        view.addCentered(logoImageView)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

//MARK: Show errors
extension SplashScreenViewController {
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "ErrorAuthAlert"
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(_):
                self.showError()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else {return}
                    self.profileImageService.fetchProfileImageURL(username: profile.userName!) {_ in }
                    UIBlockingProgressHUD.hide()
                    self.switchToTabBarController()
                }
                break
            case .failure:
                self.showError()
                break
            }
        }
    }
}
