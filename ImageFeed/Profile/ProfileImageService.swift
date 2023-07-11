//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Виктор on 11.07.2023.
//

import Foundation

struct UserResult: Decodable {
    let smallImage: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
        
        enum SmallImageKeys: String, CodingKey {
            case smallImage = "small"
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        let smallImageContainer = try container.nestedContainer(keyedBy: CodingKeys.SmallImageKeys.self, forKey: .profileImage)
        smallImage = try smallImageContainer.decode(String.self, forKey: .smallImage)
    }
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    
    private(set) var avatarURL: String?
    private var activeTask: URLSessionTask?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> ()) {
        assert(Thread.isMainThread)
        activeTask?.cancel()
        
        guard let token = OAuth2Service().authToken else { return }
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let decodedProfileImage = try? JSONDecoder().decode(UserResult.self, from: data)
                guard let decodedProfileImage = decodedProfileImage?.smallImage else { return }
                self.avatarURL = decodedProfileImage
                completion(.success(self.avatarURL!))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
        activeTask = task
        task.resume()
    }
}
