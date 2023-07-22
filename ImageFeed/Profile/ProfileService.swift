//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Виктор on 10.07.2023.
//

import Foundation

//MARK: Protocols
protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> ())
}

final class ProfileService: ProfileServiceProtocol {
    static let shared: ProfileServiceProtocol = ProfileService()
    
    private(set) var profile: Profile?
    private var activeTask: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> ()) {
        activeTask?.cancel()
        
        var request = URLRequest.makeHTTPRequest(path: "/me")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = self.makeProfileStruct(from: profile)
                completion(.success(self.profile!))
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
    
    private func makeProfileStruct(from profileResult: ProfileResult) -> Profile {
        return Profile(profileResult: profileResult)
    }
}
