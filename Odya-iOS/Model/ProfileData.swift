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
    
    func encodeToString() -> String {
        if let encodedData = try? JSONEncoder().encode(self) {
            return String(data: encodedData, encoding: .utf8) ?? ""
        }
        return ""
    }
}

extension String {
    func decodeToProileData() -> ProfileData {
        if let data = self.data(using: .utf8),
           let decodedData = try? JSONDecoder().decode(ProfileData.self, from: data) {
            return decodedData
        }
        return ProfileData(profileUrl: "")
        
        // return ProfileData(profileUrl: "https://objectstorage.ap-chuncheon-1.oraclecloud.com/p/0wFrAwWxeRqeXG2gq38hIP4o0RpirOq9N0bwgctw51KZE43OtSraBRE4qGBL97P7/n/axivk99fjind/b/Odya-stable/o/default_profile.png", profileColor: nil)
    }
}
