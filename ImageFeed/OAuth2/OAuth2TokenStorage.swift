//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Виктор on 03.07.2023.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token")
        }
    }
    
    //MARK: reset auth
    func resetToken() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
