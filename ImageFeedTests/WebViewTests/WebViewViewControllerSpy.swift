//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Виктор on 14.08.2023.
//

@testable import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadDidCalled = false
    
    func load(_ request: URLRequest) {
        loadDidCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
