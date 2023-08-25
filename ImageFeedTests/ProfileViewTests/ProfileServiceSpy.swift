//
//  ProfileServiceSpy.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

@testable import ImageFeed
import Foundation

final class ProfileServiceSpy: ProfileServiceProtocol {
    var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> ()) {
        profile = Profile(profileResult: ProfileResult(userName: "test",
                                                       firstName: "test",
                                                       lastName: "test",
                                                       bio: "test"))
    }
}
