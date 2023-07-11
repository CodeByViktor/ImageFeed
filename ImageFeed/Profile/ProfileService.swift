//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виктор on 10.07.2023.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

final class ProfileService: ProfileServiceProtocol {
    static let shared: ProfileServiceProtocol = ProfileService()
    
    private(set) var profile: Profile?
    private var activeTask: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> ()) {
        assert(Thread.isMainThread)
        activeTask?.cancel()
        
        var request = URLRequest.makeHTTPRequest(path: "/me")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let decodedProfile = try? JSONDecoder().decode(ProfileResult.self, from: data)
                guard let decodedProfile = decodedProfile else { return }
                self.profile = self.makeProfileStruct(from: decodedProfile)
                completion(.success(self.profile!))
                break
            case .failure(let error):
                
                break
            }
        }
        activeTask = task
        task.resume()
    }
    
    private func makeProfileStruct(from profileResult: ProfileResult) -> Profile {
        return Profile(username: profileResult.userName,
                       firstName: profileResult.firstName,
                       lastName: profileResult.lastName,
                       bio: profileResult.bio)
    }
}
