//
//  FeedNotificationViewModel.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/01.
//

import Foundation
import RealmSwift
import SwiftUI

final class FeedNotificationViewModel: ObservableObject {
  private var realm: Realm {
    let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS")
    let realmURL = container?.appendingPathComponent("default.realm")
    let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
    return try! Realm(configuration: config)
  }
  
  @Published var dummyData = [TestNotification]()
  @Published var notificationList = [NotificationData]()
  
  let testImageUrl = "https://images.unsplash.com/photo-1706606991536-e39841f5f598?q=80&w=3115&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
  
  func readSavedNotifications() {
    let notifications = realm.objects(NotificationData.self)
  }
  
  func getDummy() {
    dummyData.append(TestNotification(
      eventType: .followingCommunity,
      communityId: 1, travelJournalId: nil, followerId: nil,
      commentContent: nil,
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
    
    dummyData.append(TestNotification(
      eventType: .followingTravelJournal,
      communityId: nil, travelJournalId: 1, followerId: nil,
      commentContent: nil,
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
    
    dummyData.append(TestNotification(
      eventType: .travelJournalTag,
      communityId: nil, travelJournalId: 2, followerId: nil,
      commentContent: nil,
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
    
    dummyData.append(TestNotification(
      eventType: .communityComment,
      communityId: 2, travelJournalId: nil, followerId: nil,
      commentContent: "댓글 내용",
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
    
    dummyData.append(TestNotification(
      eventType: .communityLike,
      communityId: 3, travelJournalId: nil, followerId: nil,
      commentContent: nil,
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
    
    dummyData.append(TestNotification(
      eventType: .followerAdd,
      communityId: nil, travelJournalId: nil, followerId: 1,
      commentContent: nil,
      userName: "길동아밥먹자",
      userProfileUrl: "", profileColorHex: "",
      contentImage: testImageUrl,
      notifiedAt: "2024-02-01")
    )
  }
}

struct TestNotification {
  let id = UUID()
  let eventType: NotificationEventType
  
  let communityId: Int?
  let travelJournalId: Int?
  let followerId: Int?
  let commentContent: String?
  
  let userName: String
  
  let userProfileUrl: String
  let profileColorHex: String
  
  let contentImage: String
  let notifiedAt: String
  
  var profileData: ProfileData {
    return ProfileData(profileUrl: userProfileUrl, profileColor: ProfileColorData(colorHex: profileColorHex))
  }
  
  var emphasizedWord: String {
    switch eventType {
    case .followingCommunity:
      return "피드"
    case .followingTravelJournal:
      return "여행 일지"
    case .travelJournalTag:
      return "여행일지"
    case .communityComment:
      return "댓글"
    case .communityLike:
      return "오댜"
    case .followerAdd:
      return "팔로우"
    }
  }
}

enum NotificationEventType: String {
  case followingCommunity = "FOLLOWING_COMMUNITY"
  case followingTravelJournal = "FOLLOWING_TRAVEL_JOURNAL"
  case travelJournalTag = "TRAVEL_JOURNAL_TAG"
  case communityComment = "COMMUNITY_COMMENT"
  case communityLike = "COMMUNITY_LIKE"
  case followerAdd = "FOLLOWER_ADD"
}

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
  
  var profileData: ProfileData {
    return ProfileData(profileUrl: userProfileUrl ?? "", profileColor: ProfileColorData(colorHex: profileColorHex ?? "000000"))
  }
  
  var emphasizedWord: String {
    let event = NotificationEventType(rawValue: eventType)
    switch event {
    case .followingCommunity:
      return "피드"
    case .followingTravelJournal:
      return "여행 일지"
    case .travelJournalTag:
      return "여행일지"
    case .communityComment:
      return "댓글"
    case .communityLike:
      return "오댜"
    case .followerAdd:
      return "팔로우"
    case .none:
      return ""
    }
  }
  
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
