//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Виктор on 22.07.2023.
//

import Foundation

protocol ImageListSeviceProtocol {
    var photos: [Photo] { get }
    var lastLoadedPage: Int? { get }
    func fetchPhotosNextPage()
}

final class ImageListService: ImageListSeviceProtocol {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        if currentTask != nil { return }
        let request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoList, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photoList):
                self.processPhotoList(photoList)
                break
            case .failure(_):
                break
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
    
    private func processPhotoList(_ photoList: PhotoList) {
        photoList.items.forEach {
            let photo = makePhotoFrom($0)
            photos.append(photo)
        }
    }
    private func makePhotoFrom(_ photoResult: PhotoResult) -> Photo {
        return Photo(id: photoResult.id,
                     size: photoResult.size,
                     createdAt: photoResult.createdAt,
                     welcomeDescription: photoResult.description,
                     thumbImageURL: photoResult.urls.thumb,
                     largeImageURL: photoResult.urls.raw,
                     isLiked: photoResult.likedByUser)
    }
}
