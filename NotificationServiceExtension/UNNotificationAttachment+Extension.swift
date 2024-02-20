//
//  UNNotificationAttachment+Extension.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/20.
//

import UIKit
import UserNotifications

extension UNNotificationAttachment {
  static func saveImageToDisk(identifier: String, data: Data, options: [AnyHashable : Any]? = nil) -> UNNotificationAttachment? {
    let fileManager = FileManager.default
    guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS") else {
      return nil
    }
    
    let directoryURL = container.appendingPathComponent("Thumbnails")
    
    // 썸네일 디렉토리가 없으면 생성
    if !fileManager.fileExists(atPath: directoryURL.path) {
      do {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
      } catch {
        print("Failed to create folder")
        return nil
      }
    }
    
    // 이미지 파일 이름 수정
    guard let fileName = identifier.split(separator: "/").last?.replacingOccurrences(of: ".webp", with: ".jpeg") else {
      return nil
    }
    // jpeg 파일로 변경 (webp는 알림에서 지원되지 않음)
    guard let jpegData = UIImage(data: data)?.jpegData(compressionQuality: 0.8) else {
      return nil
    }
    
    // 이미지 데이터 저장
    do {
      let fileURL = directoryURL.appendingPathComponent(fileName)
      try jpegData.write(to: fileURL)
      let attachment = try UNNotificationAttachment(identifier: identifier, url: fileURL, options: options)
      return attachment
    } catch {
      print("Failed to save image to disk with \(error.localizedDescription)")
    }
    
    return nil
  }
}
