//
//  UserAuth.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/25.
//

import Foundation

struct UserInfo {
    var idToken: String = ""
    var username: String = ""
    var email: String? = nil
    var nickname: String = ""
    var phoneNumber: String? = nil
    var gender: String = ""
    var birthday: [Int] = []
    
    static func getDummy() -> Self {
        return UserInfo(idToken: "testIdToken", username: "KAKAO_1234", email: "test@test.com", nickname: "testNickname", gender: "M", birthday: [1999, 10, 10])
    }
}

//struct AppleAuth
