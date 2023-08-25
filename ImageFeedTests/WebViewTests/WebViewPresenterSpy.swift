//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Виктор on 11.08.2023.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var testVar: Bool = false
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        testVar = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        nil
    }
}
