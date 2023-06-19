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
    @UserDefault(key: keyEnum_APPLE_USER.isValid.rawValue, defaultValue: false)
    static var isValid: Bool
    
    @UserDefault(key: keyEnum_APPLE_USER.userIdentifier.rawValue, defaultValue: "")
    static var userIdentifier: String
    
    @UserDefault(key: keyEnum_APPLE_USER.familyName.rawValue, defaultValue: "")
    static var familyName: String
    
    @UserDefault(key: keyEnum_APPLE_USER.givenName.rawValue, defaultValue: "")
    static var givenName: String

    @UserDefault(key: keyEnum_APPLE_USER.email.rawValue, defaultValue: "")
    static var email: String
}

/// 최근 검색어 저장
struct SearchData {
    @UserDefault(key: keyEnum_Search.recentSearchText.rawValue, defaultValue: [String]())
    static var recentSearchText: [String]
}

enum keyEnum_APPLE_USER: String {
    case isValid
    case userIdentifier
    case familyName
    case givenName
    case email
}

enum keyEnum_Search: String {
    case recentSearchText
}
