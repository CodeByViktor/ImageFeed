//
//  ImageListServiceSpy.swift
//  ImageFeed
//
//  Created by Виктор on 16.08.2023.
//

import Foundation

final class ImageListServiceSpy: ImageListSeviceProtocol {
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        for _ in 0...9 {
            photos.append(Photo(id: "test", size: CGSize(), createdAt: Date(), welcomeDescription: nil, thumbImageURL: "test", largeImageURL: "test", isLiked: false))
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ()) {
        
    }
}
