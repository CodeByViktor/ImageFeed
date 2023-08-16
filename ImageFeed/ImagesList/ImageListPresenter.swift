//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Виктор on 15.08.2023.
//

import Foundation

protocol ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadNextPage()
    func getPhotos() -> [Photo]
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ())
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imageListService: ImageListSeviceProtocol
    private var showedPhotoCount = 0
    
    init(imageListService: ImageListSeviceProtocol) {
        self.imageListService = imageListService
    }
    
    func viewDidLoad() {
        setupObservers()
        loadNextPage()
    }
    
    func loadNextPage() {
        imageListService.fetchPhotosNextPage()
    }
    
    func getPhotos() -> [Photo] {
        return imageListService.photos
    }
    
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ()) {
        imageListService.changeLike(photoId: photoId, isLike: isLike) {result in
            switch result {
            case .success(let isLiked):
                comlition(.success(isLiked))
            case .failure(let error):
                comlition(.failure(error))
            }
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification,
                                               object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.didLoadedNewPage()
        }
    }
    
    private func didLoadedNewPage() {
        let newPhotoCount = imageListService.photos.count
        if showedPhotoCount != newPhotoCount {
            let indexPaths = (showedPhotoCount..<newPhotoCount).map { i in
                IndexPath(row: i, section: 0)
            }
            showedPhotoCount = newPhotoCount
            view?.updateTableViewAnimated(with: indexPaths)
        }
    }
}
