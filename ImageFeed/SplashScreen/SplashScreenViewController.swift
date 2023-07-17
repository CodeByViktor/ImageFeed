//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    // MARK: UI el
    private let logoImageView = {
        let view = UIImageView(image: UIImage(named: "Vector"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // ---
    
    private let profileService: ProfileServiceProtocol = ProfileService.shared
    private let profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token: token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let authController = storyboard.instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            authController.delegate = self
            authController.modalPresentationStyle = .fullScreen
            present(authController, animated: true)
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

//MARK: UI
extension SplashScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
                self.dismiss(animated: true) {
                    self.profileImageService.fetchProfileImageURL(username: profile.username!) { _ in }
                    UIBlockingProgressHUD.hide()
                    self.switchToTabBarController()
                }
                break
            case .failure(_):
                self.showError()
                break
            }
        }
    }
}
