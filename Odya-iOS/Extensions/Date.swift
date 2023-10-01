//
//  Date.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/18.
//

import Foundation

extension Date {
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func addDays(_ daysToAdd: Int) -> Date? {
        var components = DateComponents()
        components.day = daysToAdd
        return Calendar.current.date(byAdding: components, to: self)
    }
}

extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
}
