//
//  Tab.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/03/03.
//

import Foundation

enum Tab: CaseIterable {
  case home
  case journal
  case feed
  case profile
  
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .journal:
      return "내추억"
    case .feed:
      return "피드"
    case .profile:
      return "내정보"
    }
  }
  
  var symbolImage: String {
    switch self {
    case .home:
      return "location-m"
    case .journal:
      return "diary"
    case .feed:
      return "messages-off"
    case .profile:
      return "person-off"
    }
  }
}
