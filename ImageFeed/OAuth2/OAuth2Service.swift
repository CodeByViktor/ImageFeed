//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation
import WebKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    
    private var lastCode: String?
    private var activeTask: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    func fetchOAuthToken(
            _ code: String,
            completion: @escaping (Result<String, Error>) -> Void )
    {
        
        guard lastCode != code && activeTask == nil else { return }
        activeTask?.cancel()
        lastCode = code
        
        let request = URLRequest.authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
            activeTask = nil
            lastCode = nil
        }
        activeTask = task
        task.resume()
    }
    
    func logout() {
        OAuth2TokenStorage.shared.resetToken()
        WebKitCookieCleaner.clean()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let splashScreenController = SplashScreenViewController()
        window.rootViewController = splashScreenController
    }
}
