//
//  UserAuth.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/25.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
  case male, female, none
  var id: Self { self }

  func toKorean() -> String {
    switch self {
    case .male: return "남성"
    case .female: return "여성"
    default: return "성별"
    }
  }

  func toServerForm() -> String {
    switch self {
    case .male: return "M"
    case .female: return "F"
    default: return ""
    }
  }
}

struct SignUpInfo {
  var idToken: String = ""
  var username: String = ""
  var email: String? = nil
  var nickname: String = ""
  var phoneNumber: String? = nil
  var gender: Gender = .none
  var birthday: Date = Date()
  var termsIdList: [Int] = []
}
