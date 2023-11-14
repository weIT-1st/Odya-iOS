//
//  String.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/07.
//

import Foundation

extension String {
  /// String타입의 날짜형식 데이터를 Date타입으로 변환
  func toExtendedDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "ko-KR")
    dateFormatter.calendar = Calendar.current
    
    return dateFormatter.date(from: self) ?? Date()
  }
  
  /// 날짜형식 데이터 String -> Date -> 상대날짜 String으로 변환
  func toCustomRelativeDateString() -> String {
    return self.toExtendedDate().toRelativeString()
  }
}
