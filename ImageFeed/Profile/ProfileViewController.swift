//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Виктор on 09.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        let avatarView = UIImageView()
        let avatarImage = UIImage(named: "Photo")
        avatarView.image = avatarImage
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        let exitButtonImage = UIImage(systemName: "ipad.and.arrow.forward")
        let exitButton = UIButton.systemButton(with: exitButtonImage!,
                                               target: self,
                                               action: #selector(logout))
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let linkLabel = UILabel()
        linkLabel.text = "@ekaterina_nov"
        linkLabel.font = UIFont.systemFont(ofSize: 13)
        linkLabel.textColor = UIColor(named: "YP Grey")
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descLabel = UILabel()
        descLabel.text = "Hello, world!"
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(named: "YP White")
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarView)
        view.addSubview(exitButton)
        view.addSubview(nameLabel)
        view.addSubview(linkLabel)
        view.addSubview(descLabel)
        
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
    }
}
