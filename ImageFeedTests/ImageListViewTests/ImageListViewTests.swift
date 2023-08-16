//
//  ImageListViewTests.swift
//  ImageFeedTests
//
//  Created by Виктор on 16.08.2023.
//

@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    func testPresenterViewDidLoad() throws {
        let vc = ImagesListViewController()
        let presenter = ImageListPresenterSpy()
        vc.presenter = presenter
        
        _ = vc.view
        
        XCTAssertTrue(presenter.testViewDidLoadCalled)
    }
    
    func testPresenterLoadNewPage() throws {
        let imageService = ImageListServiceSpy()
        let presenter = ImageListPresenter(imageListService: imageService)
        
        presenter.loadNextPage()
        
        XCTAssertEqual(presenter.getPhotosCount(), 10)
    }
}
