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
    let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
    return try! Realm(configuration: config)
  }
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    if let bestAttemptContent = bestAttemptContent {
      // Modify the notification content here...
      saveNotificationData(userInfo: bestAttemptContent.userInfo)

      bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
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
    let original = realm.objects(NotificationData.self)
    print(original)
    guard let eventType = data["eventType"] as? String, let userName = data["userName"] as? String, let notifiedAt = data["notifiedAt"] as? String else { return }
    
    let communityId = data["communityId"] as? Int
    let travelJournalId = data["travelJournalId"] as? Int
    let followerId = data["followerId"] as? Int
    let commentContent = data["commentContent"] as? String
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
    }
  }
}
