//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виктор on 09.06.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateUI(with profile: Profile)
    func updateAvatar(with url: URL)
}

//MARK: Class
final class ProfileViewController: BaseViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: UI el
    private let avatarView = {
        let view = UIImageView(image: UIImage(named: "person.crop.circle.fill"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let exitButton = {
        let exitButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        let button = UIButton.systemButton(with: exitButtonImage!,
                                           target: nil,
                                           action: nil)
        button.accessibilityIdentifier = "logoutButtonIdentifier"
        button.tintColor = UIColor(named: "YP Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel = {
        let nameLabel = UILabel()
        nameLabel.accessibilityIdentifier = "nameLabelIdentifier"
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let linkLabel = {
        let linkLabel = UILabel()
        linkLabel.accessibilityIdentifier = "linkLabelIdentifier"
        linkLabel.text = "@ekaterina_nov"
        linkLabel.font = UIFont.systemFont(ofSize: 13)
        linkLabel.textColor = UIColor(named: "YP Grey")
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        return linkLabel
    }()
    
    private let descLabel = {
        let descLabel = UILabel()
        descLabel.text = "Hello, world!"
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(named: "YP White")
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        return descLabel
    }()
    //------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP Black")

        exitButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        addSubViews()
        applyConstraints()
        
        presenter?.viewDidLoad()
    }
    
    func updateUI(with profile: Profile) {
        nameLabel.text = profile.name
        linkLabel.text = profile.loginName
        descLabel.text = profile.bio
    }
    
    func updateAvatar(with url: URL) {
        let imageProcessor = RoundCornerImageProcessor(cornerRadius: 60)
        avatarView.kf.setImage(with: url,
                               placeholder: UIImage(named: "person.crop.circle.fill"),
                               options: [.processor(imageProcessor)])
    }
    
    private func addSubViews() {
        view.addSubview(avatarView)
        view.addSubview(exitButton)
        view.addSubview(nameLabel)
        view.addSubview(linkLabel)
        view.addSubview(descLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalToConstant: 70),
            avatarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            linkLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            descLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor)
        ])
    }
    
    @objc
    private func logout(_ sender: Any) {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            OAuth2Service.shared.logout()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
}
