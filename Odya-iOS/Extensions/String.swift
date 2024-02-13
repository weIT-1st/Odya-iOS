//
//  String.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/07.
//

import Foundation

extension String {
  
  /// 날짜형식 데이터 String -> Date -> 상대날짜 String으로 변환
  func toCustomRelativeDateString() -> String {
    if let result = self.toDate(format: "yyyy-MM-dd HH:mm:ss")?.toRelativeString() {
      return result
    } else if let result = self.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")?.toRelativeString() {
      return result
    } else {
      return self
    }
  }
  
  /// 글자단위 줄바꿈위해
  func splitCharacter() -> String {
    return self.split(separator: "").joined(separator: "\u{200B}")
  }
}

extension String {
  func toJournalPrivacyType() -> PrivacyType {
    switch self {
    case "PUBLIC":
      return .global
    case "FRIEND_ONLY":
      return .friendsOnly
    case "PRIVATE":
      return .personal
    default:
      return .global
    }
  }
}

// MARK: - 휴대폰 번호 검증
extension String {
  public func validatePhoneNumber() -> Bool {
    let regex = "01([0|1|6|7|8|9])-([0-9]{3,4})-([0-9]{4})"
    return NSPredicate(format: "SELF MATCHES %@", regex)
      .evaluate(with: self)
  }
}

// MARK: count
extension String {
  func countCharacters() -> Int {
    var count = 0
    for scalar in self.unicodeScalars {
      // 이모지(Emoji)는 스칼라 값이 1,2로 구성되어 있습니다.
      // 나머지는 모두 1로 계산합니다.
      count += scalar.value > 0xFFFF ? 2 : 1
    }
    return count
  }
}
