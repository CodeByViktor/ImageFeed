//
//  Constants.swift
//  ImageFeed
//
//  Created by Виктор on 30.06.2023.
//

import Foundation

let gDefaultBaseURL = URL(string: "https://api.unsplash.com")!
let gAuthUrl = "https://unsplash.com/oauth/authorize"
let gAccessKey = "HdOZmJg-AxkwrDC8rIePQPEREv2TE_bHvzhLeutLaCM"
let gSecretKey = "aAYiGXVXzJ3ewkQyevhxBe9oiK5YgKaTqe_ec_aQwT4"
let gRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let gAccessScope = "public+read_user+write_likes"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: gAccessKey,
                                 secretKey: gSecretKey,
                                 redirectURI: gRedirectURI,
                                 accessScope: gAccessScope,
                                 authURLString: gAuthUrl,
                                 defaultBaseURL: gDefaultBaseURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
