//
//  Date.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import Foundation

extension Date {
  public var year: Int {
    return Calendar.current.component(.year, from: self)
  }
  
  public var month: Int {
    return Calendar.current.component(.month, from: self)
  }
  
  public var day: Int {
    return Calendar.current.component(.day, from: self)
  }
  
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toIntArray() -> [Int] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return [components.year ?? 0, components.month ?? 0, components.day ?? 0]
    }
    
    func addDays(_ daysToAdd: Int) -> Date? {
        var components = DateComponents()
        components.day = daysToAdd
        return Calendar.current.date(byAdding: components, to: self)
    }
  
  /**
   # toRelativeString
   - Note: 기획 기준에 따라 상대날짜로 변환
   - Returns: '방금전', '1일전' 등의 문자열
   */
  func toRelativeString() -> String {
    var dateToString = ""
    // 방금전: 3시간
    if -self.timeIntervalSinceNow < 3 * 60 * 60 {
      dateToString = "방금전"
    } else if self.year == Date.now.year && self.month == Date.now.month && self.day == Date.now.day {
      // 오늘
      dateToString = "오늘"
    } else if self > Calendar.current.date(byAdding: .day, value: -30, to: Date.now)! {
      // 1일전 ~ 30일전
      let difference = Calendar.current.numberOfDaysBetween(self, and: Date.now)
      return "\(difference)일전"
    } else if self.year == Date.now.year {
      // 올해
      dateToString = self.dateToString(format: "M월 dd일")
    } else {
      // 그외
      dateToString = self.dateToString(format: "yyyy년 M월 dd일")
    }
    return dateToString
  }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "GMT") // 시간대를 GMT로 설정
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
}

extension Calendar {
  func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
    let fromDate = startOfDay(for: from)
    let toDate = startOfDay(for: to)
    let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
    
    return numberOfDays.day!
  }
}
