//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Виктор on 11.07.2023.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> ())
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private var activeTask: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> ()) {
        activeTask?.cancel()
        
        guard let token = OAuth2Service.shared.authToken else { return }
        let request = URLRequest.profileImageRequest(for: username)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.smallImage
                completion(.success(self.avatarURL!))
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                object: self,
                                                userInfo: ["URL": self.avatarURL!])
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
            activeTask = nil
        }
        activeTask = task
        task.resume()
    }
}
