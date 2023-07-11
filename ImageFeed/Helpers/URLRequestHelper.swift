//
//  URLRequestHelper.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
            path: String,
            httpMethod: String = "GET",
            baseURL: URL = DefaultBaseURL
        ) -> URLRequest {
            var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
            request.httpMethod = httpMethod
            return request
    }
}
