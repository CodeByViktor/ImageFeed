//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    var profileService: ProfileServiceProtocol
    var profileImageService: ProfileImageServiceProtocol
    
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        getProfile()
        setupObserver()
        getAvatarUrl()
    }
    
    private func getProfile() {
        guard let profile = profileService.profile else { return }
        view?.updateUI(with: profile)
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.getAvatarUrl()
        }
    }
    
    private func getAvatarUrl() {
        guard
            let profileImage = profileImageService.avatarURL,
            let imageURL = URL(string: profileImage)
        else { return }
        view?.updateAvatar(with: imageURL)
    }
}
