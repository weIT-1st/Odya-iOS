//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/15.
//

import UIKit
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
    
    print("didReceive!!")
    if let bestAttemptContent = bestAttemptContent {
      // Modify the notification content here...
      print("Data payload 확인: \(bestAttemptContent.userInfo)")
      
      /*/ 알림 설정 따라 저장되는 알림 거르기
      if NotiSetting.allEnabled {
        saveNotificationData(userInfo: bestAttemptContent.userInfo)
      } else {
        let title = bestAttemptContent.title
        if title == "오댜 알림" 
            && NotiSetting.feedOdyaEnabled {
          saveNotificationData(userInfo: bestAttemptContent.userInfo)
        }
        else if title == "댓글 알림"
            && NotiSetting.feedCommentEnabled {
          saveNotificationData(userInfo: bestAttemptContent.userInfo)
        }
      }
      */
      
      saveNotificationData(userInfo: bestAttemptContent.userInfo)
      
      // handle image
      guard let contentImage = bestAttemptContent.userInfo["contentImage"] as? String else {
        contentHandler(bestAttemptContent)
        return
      }
      
      let imageURL = URL(string: contentImage)!
      
      // 이미지 다운로드
      guard let imageData = try? Data(contentsOf: imageURL) else {
        contentHandler(bestAttemptContent)
        return
      }
      
      guard let attachment = UNNotificationAttachment.attachImageData(identifier: contentImage, data: imageData) else {
        contentHandler(bestAttemptContent)
        return
      }
      bestAttemptContent.attachments = [attachment]
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
    if let contentImage {
      saveImageToDisk(imageURL: contentImage)
    }
    let userProfileUrl = data["userProfileUrl"] as? String
    if let userProfileUrl {
      saveImageToDisk(imageURL: userProfileUrl)
    }
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
  
  private func saveImageToDisk(imageURL imageURLString: String) {
    let fileManager = FileManager.default
    guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS") else {
      return
    }
    
    let thumbnailURL = container.appendingPathComponent("Thumbnails")
    // 썸네일 디렉토리가 없으면 생성
    if !fileManager.fileExists(atPath: thumbnailURL.path) {
      do {
        try fileManager.createDirectory(at: thumbnailURL, withIntermediateDirectories: false)
      } catch {
        print("Failed to create folder")
        return
      }
    }
    
    let imageURL = URL(string: imageURLString)!
    let fileName = imageURL.lastPathComponent
    guard let data = try? Data(contentsOf: imageURL) else {
      return
    }
    
    let fileURL = thumbnailURL.appendingPathComponent(fileName)
    fileManager.createFile(atPath: fileURL.path, contents: data)
  }
}
