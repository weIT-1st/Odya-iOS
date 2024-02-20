//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/15.
//

import UserNotifications
import RealmSwift

class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  
  private var realm: Realm {
    let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS")
    let realmURL = container?.appendingPathComponent("default.realm")
    let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 2)
    return try! Realm(configuration: config)
  }
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    if let bestAttemptContent = bestAttemptContent {
      // Modify the notification content here...
      print("Data payload 확인: \(bestAttemptContent.userInfo)")
      saveNotificationData(userInfo: bestAttemptContent.userInfo)
      
      contentHandler(bestAttemptContent)
    }
  }
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
  
  private func saveNotificationData(userInfo data: [AnyHashable: Any]) {
    guard let eventType = data["eventType"] as? String, let userName = data["userName"] as? String, let notifiedAt = data["notifiedAt"] as? String else { return }
    
    let communityId = Int(data["communityId"] as? String ?? "")
    let travelJournalId = Int(data["travelJournalId"] as? String ?? "")
    let followerId = Int(data["followerId"] as? String ?? "")
    let commentContent = data["content"] as? String
    let contentImage = data["contentImage"] as? String
    let userProfileUrl = data["userProfileUrl"] as? String
    let profileColorHex = data["profileColorHex"] as? String
    
    let savedData = NotificationData(
      eventType: eventType,
      userName: userName,
      notifiedAt: notifiedAt,
      communityId: communityId,
      travelJournalId: travelJournalId,
      followerId: followerId,
      commentContent: commentContent,
      contentImage: contentImage,
      userProfileUrl: userProfileUrl,
      profileColorHex: profileColorHex
    )
    
    do {
      try realm.write {
        realm.add(savedData)
      }
    } catch {
      print("알림 데이터 저장 실패")
      return
    }
    
    updateIconState()
  }
  
  private func updateIconState() {
    if let state = realm.objects(NotificationIconState.self).first {
      // update
      do {
        try realm.write {
          state.unreadNotificationExists = true
        }
      } catch {
        print("알림 아이콘 상태 업데이트 실패")
      }
    } else {
      let newState = NotificationIconState(unreadNotificationExists: true)
      do {
        try realm.write {
          realm.add(newState)
        }
      } catch {
        print("알림 아이콘 상태 저장 실패")
      }
    }
  }
}
