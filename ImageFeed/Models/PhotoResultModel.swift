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
    let created_at: Date?
    let description: String?
    let urls: UrlsResult
    let liked_by_user: Bool
    
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}
