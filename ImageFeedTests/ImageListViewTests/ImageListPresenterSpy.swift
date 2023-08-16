//
//  ImageListPresenterSpy.swift
//  ImageFeed
//
//  Created by Виктор on 16.08.2023.
//

@testable import ImageFeed
import Foundation

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var imageListService: ImageListSeviceProtocol = ImageListServiceSpy()
    
    var testViewDidLoadCalled = false
    var testLoadNextPageCalled = false
    
    func viewDidLoad() {
        testViewDidLoadCalled = true
        loadNextPage()
    }
    
    func loadNextPage() {
        testLoadNextPageCalled = true
        imageListService.fetchPhotosNextPage()
    }
    
    func getPhotos() -> [Photo] {
        return imageListService.photos
    }
    
    func changeLike(photoId: String, isLike: Bool, _ comlition: @escaping (Result<Bool, Error>) -> ()) {
    }
    func getPhoto(by indexPath: IndexPath) -> ImageFeed.Photo {
        return imageListService.photos[indexPath.row]
    }
    
    func getPhotosCount() -> Int {
        return imageListService.photos.count
    }
    
    func getCellInfo(by indexPath: IndexPath) -> ImagesListCellModel? {
        let testUrl = URL(string: "http://test")!
        return ImagesListCellModel(url: testUrl, dateString: "test", isLiked: false)
    }
}
