//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation

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
        assert(Thread.isMainThread)
        
        if lastCode == code && activeTask != nil { return }
        activeTask?.cancel()
        lastCode = code
        
        let request = authTokenRequest(code: code)
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
    
//    private func object(
//            for request: URLRequest,
//            completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                Result {
//                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
//                }
//            }
//            completion(response)
//        }
//    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest {
        return URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
