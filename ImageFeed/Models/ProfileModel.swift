//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Виктор on 21.07.2023.
//

import Foundation

struct Profile {
    let userName: String?
    var loginName: String?
    let firstName: String?
    let lastName: String?
    var name: String?
    let bio: String?
    
    init(profileResult: ProfileResult) {
        userName = profileResult.userName
        loginName = "@\(userName ?? "")"
        firstName = profileResult.firstName
        lastName = profileResult.lastName
        name = "\(firstName ?? "") \(lastName ?? "")"
        bio = profileResult.bio
    }
}
