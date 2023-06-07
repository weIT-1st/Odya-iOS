//
//  UserDefaults.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/04.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

/// 애플 유저 데이터 저장
struct AppleUserData {
    @UserDefault(key: keyEnum_APPLE_USER.userIdentifier.rawValue, defaultValue: "")
    static var userIdentifier: String
    
    @UserDefault(key: keyEnum_APPLE_USER.familyName.rawValue, defaultValue: "")
    static var familyName: String
    
    @UserDefault(key: keyEnum_APPLE_USER.givenName.rawValue, defaultValue: "")
    static var givenName: String

    @UserDefault(key: keyEnum_APPLE_USER.email.rawValue, defaultValue: "")
    static var email: String
}

enum keyEnum_APPLE_USER: String {
    case userIdentifier
    case familyName
    case givenName
    case email
}
