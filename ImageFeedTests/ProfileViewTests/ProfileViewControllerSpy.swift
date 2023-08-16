//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    var testUpdateUICalled = false
    var testUpdateAvatarCalled = false
    
    func updateUI(with profile: Profile) {
        testUpdateUICalled = true
    }
    
    func updateAvatar(with url: URL) {
        testUpdateAvatarCalled = true
    }
}
