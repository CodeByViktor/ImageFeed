//
//  PhotosResult.swift
//  ImageFeed
//
//  Created by Виктор on 22.07.2023.
//

import Foundation

struct PhotoList: Decodable {
    let items: [PhotoResult]
}

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
}
