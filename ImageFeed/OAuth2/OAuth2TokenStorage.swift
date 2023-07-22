//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: "Auth token")
        }
    }
    
    //MARK: reset auth
    func resetToken() {
        KeychainWrapper.standard.removeObject(forKey: "Auth token")
    }
}
