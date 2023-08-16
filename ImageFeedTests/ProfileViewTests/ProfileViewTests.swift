//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Виктор on 14.08.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testPresenterViewDidLoad() throws {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.testDidloadCalled)
    }
    
    func testProfileViewUpdateUI() throws {
        let viewController = ProfileViewControllerSpy()
        
        let profileService = ProfileServiceSpy()
        profileService.fetchProfile("") {_ in}
        let profileImageService = ProfileImageServiceSpy()
        
        let presenter = ProfileViewPresenter(profileService: profileService,
                                             profileImageService: profileImageService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.testUpdateUICalled)
    }
    
    func testProfileViewUpdateAvatar() throws {
        let viewController = ProfileViewControllerSpy()
        
        let profileService = ProfileServiceSpy()
        let profileImageService = ProfileImageServiceSpy()
        profileImageService.fetchProfileImageURL(username: "") {_ in}
        
        let presenter = ProfileViewPresenter(profileService: profileService,
                                             profileImageService: profileImageService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.testUpdateAvatarCalled)
    }
}
