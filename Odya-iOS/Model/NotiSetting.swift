//
//  NotiSetting.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2/18/24.
//

import SwiftUI
import Foundation

/// 알람 세부 설정
struct NotificationSetting: Identifiable {
  let id = UUID()
  let notiCase: keyEnum_NotiSetting
  let title: String
  var isOn: Bool = false
  
  init(_ notiCase: keyEnum_NotiSetting) {
    self.notiCase = notiCase
  
    switch notiCase {
    case .all:
      self.title = "전체 알람"
      self.isOn = NotiSetting.allEnabled
    case .feedOdya:
      self.title = "커뮤니티 좋아요 알람"
      self.isOn = NotiSetting.feedOdyaEnabled
    case .feedComment:
      self.title = "커뮤니티 댓글 알람"
      self.isOn = NotiSetting.feedCommentEnabled
    case .marketing:
      self.title = "마케팅 알람"
      self.isOn = NotiSetting.marketingEnabled
    }
  }
  
  /// 변경된 isOn(뷰만 변경) 값을 UserDefaults에 저장
  mutating func setEnabled() {
    switch notiCase {
    case .all:
      NotiSetting.allEnabled = isOn
    case .feedOdya:
      NotiSetting.feedOdyaEnabled = isOn
    case .feedComment:
      NotiSetting.feedCommentEnabled = isOn
    case .marketing:
      NotiSetting.marketingEnabled = isOn
    }
  }
}

// MARK: User Defaults (App Group)
@propertyWrapper
struct UserDefaultAppGroup<T> {
  private let key: String
  private let defaultValue: T
  private var container: UserDefaults

  init(key: String, defaultValue: T, suiteName: String?) {
    self.key = key
    self.defaultValue = defaultValue
    if let suiteName = suiteName,
        let userDefaults = UserDefaults(suiteName: suiteName) {
      self.container = userDefaults
    } else {
      self.container = UserDefaults.standard
    }
  }

  var wrappedValue: T {
    get {
      return container.object(forKey: key) as? T ?? defaultValue
    }
    set {
      container.set(newValue, forKey: key)
    }
  }
}

struct NotiSetting {
  @UserDefaultAppGroup(key: keyEnum_NotiSetting.all.rawValue, defaultValue: true, suiteName: "group.com.weit.Odya-iOS")
  static var allEnabled: Bool

  @UserDefaultAppGroup(key: keyEnum_NotiSetting.feedOdya.rawValue, defaultValue: true, suiteName: "group.com.weit.Odya-iOS")
  static var feedOdyaEnabled: Bool
  
  @UserDefaultAppGroup(key: keyEnum_NotiSetting.feedComment.rawValue, defaultValue: true, suiteName: "group.com.weit.Odya-iOS")
  static var feedCommentEnabled: Bool
  
  @UserDefaultAppGroup(key: keyEnum_NotiSetting.marketing.rawValue, defaultValue: true, suiteName: "group.com.weit.Odya-iOS")
  static var marketingEnabled: Bool
}

enum keyEnum_NotiSetting: String {
  case all
  case feedOdya
  case feedComment
  case marketing
}
