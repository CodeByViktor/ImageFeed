//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Виктор on 22.07.2023.
//

import Foundation

protocol ImageListSeviceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
}

final class ImageListService: ImageListSeviceProtocol {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var token = OAuth2TokenStorage.shared.token
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard currentTask == nil, let token = token else { return }
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)&order_by=latest")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photoList):
                self.processPhotoList(photoList)
                NotificationCenter.default.post(name: ImageListService.DidChangeNotification,
                                                object: self)
                self.lastLoadedPage = nextPage
                break
            case .failure(_):
                break
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Void, Error>) -> ()) {
        var request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like")

    }
    
    private func processPhotoList(_ photoList: [PhotoResult]) {
        photoList.forEach {
            let photo = makePhotoFrom($0)
            photos.append(photo)
        }
    }
    private func makePhotoFrom(_ photoResult: PhotoResult) -> Photo {
        return Photo(id: photoResult.id,
                     size: photoResult.size,
                     createdAt: photoResult.created_at,
                     welcomeDescription: photoResult.description,
                     thumbImageURL: photoResult.urls.thumb,
                     largeImageURL: photoResult.urls.raw,
                     isLiked: photoResult.liked_by_user)
    }
}
