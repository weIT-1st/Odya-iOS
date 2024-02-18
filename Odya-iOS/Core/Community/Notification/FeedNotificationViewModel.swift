//
//  FeedNotificationViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/01.
//

import RealmSwift
import SwiftUI

final class FeedNotificationViewModel: ObservableObject {
  // MARK: Properties
  
  private var realm: Realm {
    let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS")
    let realmURL = container?.appendingPathComponent("default.realm")
    let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
    return try! Realm(configuration: config)
  }
  
  @Published var notificationList = [NotificationData]()
  
  // MARK: Helper functions
  
  /// 저장된 알림 데이터 읽어오기
  func readSavedNotifications() {
    let tasks = realm.objects(NotificationData.self).sorted(byKeyPath: "notifiedAt", ascending: false)
    print(tasks)
    self.notificationList = Array(tasks)
  }
}
