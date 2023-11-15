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
