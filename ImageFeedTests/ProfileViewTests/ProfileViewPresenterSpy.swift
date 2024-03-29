//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var testDidloadCalled = false
    
    func viewDidLoad() {
        testDidloadCalled = true
    }
}
