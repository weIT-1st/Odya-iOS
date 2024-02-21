//
//  UNNotificationAttachment+Extension.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/20.
//

import UIKit
import UserNotifications

extension UNNotificationAttachment {
  static func attachImageData(identifier: String, data: Data, options: [AnyHashable : Any]? = nil) -> UNNotificationAttachment? {
    let fileManager = FileManager.default
    let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    // 이미지 파일 이름 수정
    guard let fileName = identifier.split(separator: "/").last?.replacingOccurrences(of: ".webp", with: ".jpeg") else {
      return nil
    }
    // jpeg 파일로 변경 (webp는 알림에서 지원되지 않음)
    guard let jpegData = UIImage(data: data)?.jpegData(compressionQuality: 0.8) else {
      return nil
    }
    
    let attachmentURL = documentURL.appendingPathComponent(fileName)
    fileManager.createFile(atPath: attachmentURL.path, contents: jpegData)
    
    // 이미지 데이터 저장
    do {
      let attachment = try UNNotificationAttachment(identifier: identifier, url: attachmentURL, options: options)
      return attachment
    } catch {
      print("Failed to save image to disk with \(error.localizedDescription)")
    }
    
    return nil
  }
}
