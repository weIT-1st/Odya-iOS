//
//  ProfileData.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/17.
//

import Foundation

struct ProfileColorData: Codable {
    var colorHex: String
}

struct ProfileData: Codable {
    var profileUrl: String
    var profileColor: ProfileColorData?
}
