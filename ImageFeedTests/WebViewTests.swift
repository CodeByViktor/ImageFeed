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
    
    func testPresenterCallsLoadRequest() throws {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadDidCalled)
    }

    func testProgressVisibleWhenLessThenOne() throws {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let value: Float = 0.5
        
        let shouldHideProgress = presenter.shouldHideProgress(for: value)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() throws {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let value: Float = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: value)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() throws {
        let authConf = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: authConf)
        
        let authUrl = authHelper.authURL()
        let urlStr = authUrl.absoluteString
        
        XCTAssertTrue(urlStr.contains(authConf.accessKey))
        XCTAssertTrue(urlStr.contains(authConf.accessScope))
        XCTAssertTrue(urlStr.contains(authConf.redirectURI))
        XCTAssertTrue(urlStr.contains(authConf.authURLString))
        XCTAssertTrue(urlStr.contains("code"))
    }
    
    func testCodeFromURL() throws {
        let authHelper = AuthHelper()
        var urlComp = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComp.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        let url = urlComp.url
        
        let codeString = authHelper.code(from: url!)
        
        XCTAssertEqual(codeString, "test code")
    }
}
