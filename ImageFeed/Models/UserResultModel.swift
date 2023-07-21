//
//  UserResultModel.swift
//  ImageFeed
//
//  Created by Виктор on 21.07.2023.
//

import Foundation

struct UserResult: Decodable {
    let smallImage: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        enum SmallImageKeys: String, CodingKey {
            case smallImage = "small"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let smallImageContainer = try container.nestedContainer(keyedBy: CodingKeys.SmallImageKeys.self, forKey: .profileImage)
        smallImage = try smallImageContainer.decode(String.self, forKey: .smallImage)
    }
}
