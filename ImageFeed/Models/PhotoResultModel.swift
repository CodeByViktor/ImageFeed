//
//  PhotosResult.swift
//  ImageFeed
//
//  Created by Виктор on 22.07.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
}
