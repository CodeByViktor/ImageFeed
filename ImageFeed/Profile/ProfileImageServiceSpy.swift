//
//  ProfileImageServiceSpy.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

import Foundation

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> ()) {
        avatarURL = "http://test"
    }
    
    
}
