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
        guard currentTask == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let request = URLRequest.photoListRequest(for: nextPage)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {return}
            self.currentTask = nil
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
        }
        currentTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ()) {
        let request = URLRequest.photoLikeRequest(for: photoId, isLike: isLike)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let photoLikeResult):
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    //let photo = self.photos[index]
                    let photoResult = photoLikeResult.photo
                    let newPhoto = makePhotoFrom(photoResult)
                    self.photos[index] = newPhoto
                    comlition(.success(newPhoto.isLiked))
                }
            case .failure(let error):
                comlition(.failure(error))
            }
        }
        task.resume()
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
                     largeImageURL: photoResult.urls.full,
                     isLiked: photoResult.liked_by_user)
    }
}
