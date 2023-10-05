//
//  UserInfo.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import SwiftUI

struct UserData: Codable {
    var userID: Int?
    var email: String?
    var nickname: String
    var phoneNumber: String?
    var gender: String
    var birthday: String
    var socialType: String
    var profileData: ProfileData
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, nickname, phoneNumber, gender, birthday, socialType
        case profileData = "profile"
    }
}
