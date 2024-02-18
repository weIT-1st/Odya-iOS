//
//  NotiSetting.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2/18/24.
//

import SwiftUI

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
      self.isOn = NotiSetting.feetOdyaEnabled
    case .feedComment:
      self.title = "커뮤니티 댓글 알람"
      self.isOn = NotiSetting.feetCommentEnabled
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
      NotiSetting.feetOdyaEnabled = isOn
    case .feedComment:
      NotiSetting.feetCommentEnabled = isOn
    case .marketing:
      NotiSetting.marketingEnabled = isOn
    }
  }
}
