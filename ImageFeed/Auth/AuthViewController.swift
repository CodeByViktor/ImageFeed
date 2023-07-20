//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: BaseViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let logoView = {
        let view = UIImageView(image: UIImage(named: "Logo_of_Unsplash"))
        return view
    }()
    private let loginButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor(named: "YP White")
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
}

//MARK: UI
extension AuthViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black")
        addSubviews()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addCentered(logoView)
        view.addPositioned(loginButton, bottomFromSafeArea: true, top: nil, left: 16, bottom: -90, right: -16, h: 48)
    }

    @objc
    private func didTapLoginButton() {
        let webiew = WebViewViewController()
        webiew.delegate = self
        webiew.modalPresentationStyle = .fullScreen
        present(webiew, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //vc.dismiss(animated: true)
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
