//
//  ProfileResultModel.swift
//  ImageFeed
//
//  Created by Виктор on 21.07.2023.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
