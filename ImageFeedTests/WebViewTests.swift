//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Виктор on 11.08.2023.
//

import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {

    func testPresenterViewDidLoad() throws {
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.testVar)
    }

}
