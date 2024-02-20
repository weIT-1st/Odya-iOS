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
    let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
    return try! Realm(configuration: config)
  }
  
  @Published var notificationList = [NotificationData]()
  
  // MARK: Helper functions
  
  /// 저장된 알림 데이터 읽어오기
  func readSavedNotifications() {
    let tasks = realm.objects(NotificationData.self).sorted(byKeyPath: "notifiedAt", ascending: false)
    print(tasks)
    self.notificationList = Array(tasks)
    
    setAllNotificationsRead()
    
    let fileManager = FileManager.default
    guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS") else {
      return
    }
    let directoryURL = container.appendingPathComponent("Thumbnails")
    
    do {
      let fileURLs = try fileManager.contentsOfDirectory(atPath: directoryURL.path)
      print("앱 그룹 내부 폴더 \(fileURLs)")
    } catch {
      print("Error reading directory \(error)")
    }
  }
  
  /// 알림을 모두 읽은 상태로 설정
  private func setAllNotificationsRead() {
    if let state = realm.objects(NotificationIconState.self).first {
      do {
        try realm.write {
          state.unreadNotificationExists = false
        }
      } catch {
        debugPrint("알림 아이콘 상태 변경 실패")
      }
    }
  }
}
