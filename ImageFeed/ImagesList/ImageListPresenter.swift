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
    func getPhoto(by indexPath: IndexPath) -> Photo
    func getPhotosCount() -> Int
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ())
    func getCellInfo(by indexPath: IndexPath) -> ImagesListCellModel?
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imageListService: ImageListSeviceProtocol
    private var showedPhotoCount = 0
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
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
    
    func getPhotosCount() -> Int {
        return imageListService.photos.count
    }
    
    func getPhoto(by indexPath: IndexPath) -> Photo {
       return imageListService.photos[indexPath.row]
    }
    
    func getCellInfo(by indexPath: IndexPath) -> ImagesListCellModel? {
        let photo = getPhoto(by: indexPath)
        guard let imageUrl = URL(string: photo.thumbImageURL) else {
            return nil
        }
        
        var dateString = ""
        if let createdDate = photo.createdAt {
            dateString = dateFormatter.string(from: createdDate)
        }
        return ImagesListCellModel(url: imageUrl,
                                   dateString: dateString,
                                   isLiked: photo.isLiked)
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
