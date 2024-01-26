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
