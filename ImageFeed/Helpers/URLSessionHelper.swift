//
//  URLSessionHelper.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask
    {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    let decoder = JSONDecoder()
                    let result = Result {
                        try decoder.decode(T.self, from: data)
                    }
                    fulfillCompletion(result)
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        }
        
        return task
    }
}
