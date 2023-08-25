//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Виктор on 16.08.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        print(app.debugDescription)
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        let loginButton = webView.descendants(matching: .button).element
        
        loginTextField.tap()
        loginTextField.typeText("placeholder")
        webView.staticTexts["Login"].tap()
        
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("placeholder")
        
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        webView.staticTexts["Login"].tap()
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
            
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell1 = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell1.waitForExistence(timeout: 5))
        cell1.swipeUp()
        let cell2 = tablesQuery.children(matching: .cell).element(boundBy: 2)
        XCTAssertTrue(cell2.waitForExistence(timeout: 5))
        cell2.swipeDown()
        XCTAssertTrue(cell1.waitForExistence(timeout: 5))
        cell1.buttons["likeButtonIdentifier"].tap()
        sleep(2)
        cell1.buttons["likeButtonIdentifier"].tap()
        sleep(2)
        cell1.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        app.buttons["backButtonIdentifier"].tap()
    }
    
    func testProfile() throws {
        let tablesQuery = app.tables
        let cell1 = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell1.waitForExistence(timeout: 5))
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts["Your name"].exists)
        XCTAssertTrue(app.staticTexts["@nickname"].exists)
        app.buttons["logoutButtonIdentifier"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }

}
