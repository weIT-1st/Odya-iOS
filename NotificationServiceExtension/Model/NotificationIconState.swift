//
//  NotificationIconState.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/20.
//

import Foundation
import RealmSwift

class NotificationIconState: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var unreadNotificationExists: Bool
  
  convenience init(unreadNotificationExists: Bool) {
    self.init()
    self.unreadNotificationExists = unreadNotificationExists
  }
}
