//
//  NotificationData.swift
//  NotificationServiceExtension
//
//  Created by Jade Yoo on 2024/02/15.
//

import Foundation
import RealmSwift

class NotificationData: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var eventType: String
  @Persisted var userName: String
  @Persisted var notifiedAt: String

  @Persisted var communityId: Int?
  @Persisted var travelJournalId: Int?
  @Persisted var followerId: Int?
  @Persisted var commentContent: String?
  @Persisted var contentImage: String?

  @Persisted var userProfileUrl: String?
  @Persisted var profileColorHex: String?
  
  convenience init(eventType: String, userName: String, notifiedAt: String, communityId: Int? = nil, travelJournalId: Int? = nil, followerId: Int? = nil, commentContent: String? = nil, contentImage: String? = nil, userProfileUrl: String? = nil, profileColorHex: String? = nil) {
    self.init()
    self.eventType = eventType
    self.userName = userName
    self.notifiedAt = notifiedAt
    self.communityId = communityId
    self.travelJournalId = travelJournalId
    self.followerId = followerId
    self.commentContent = commentContent
    self.contentImage = contentImage
    self.userProfileUrl = userProfileUrl
    self.profileColorHex = profileColorHex
  }
}
