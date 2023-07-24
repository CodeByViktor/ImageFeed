//
//  URLRequestHelper.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation

extension URLRequest {
    fileprivate static func makeHTTPRequest(
            path: String,
            httpMethod: String = "GET",
            baseURL: URL = DefaultBaseURL
        ) -> URLRequest {
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.httpMethod = httpMethod
            return request
    }
    
    fileprivate mutating func useToken() {
        if let token = OAuth2TokenStorage.shared.token {
            setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
    
    static func authTokenRequest(code: String) -> URLRequest {
        return makeHTTPRequest(
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
    
    static func profileRequest() -> URLRequest {
        var request = makeHTTPRequest(path: "/me")
        request.useToken()
        return request
    }
    
    static func profileImageRequest(for username: String) -> URLRequest {
        var request = makeHTTPRequest(path: "/users/\(username)")
        request.useToken()
        return request
    }
    
    static func photoListRequest(for page: Int) -> URLRequest {
        var request = makeHTTPRequest(path: "/photos?page=\(page)&order_by=latest")
        request.useToken()
        return request
    }
    
    static func photoLikeRequest(for photoId: String, isLike: Bool) -> URLRequest {
        var request = makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: isLike ? "POST" : "DELETE")
        request.useToken()
        return request
    }
}
