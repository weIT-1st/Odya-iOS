//
//  NotificationData.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/18.
//

import SwiftUI
import RealmSwift

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
  
  var profileImage: Image? {
    guard let path = getImageFilePath(imageURL: userProfileUrl) else {
      return nil
    }

    guard let uiImage = UIImage(contentsOfFile: path) else {
      debugPrint("이미지 변환 실패")
      return nil
    }
    
    return Image(uiImage: uiImage)
  }
  
  var thumbnailImage: Image? {
    guard let path = getImageFilePath(imageURL: contentImage) else {
      return nil
    }

    guard let uiImage = UIImage(contentsOfFile: path) else {
      debugPrint("이미지 변환 실패")
      return nil
    }
    
    return Image(uiImage: uiImage)
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
  
  func getImageFilePath(imageURL: String?) -> String? {
    guard let imageURLString = imageURL else {
      return nil
    }
    
    let fileManager = FileManager.default
    guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.weit.Odya-iOS") else {
      return nil
    }
    
    let directoryURL = container.appendingPathComponent("Thumbnails")
    let fileName = URL(string: imageURLString)!.lastPathComponent
    let fileURL = directoryURL.appendingPathComponent(fileName, conformingTo: .webP)
    
    if !fileManager.fileExists(atPath: fileURL.path) {
      return nil
    }
    
    return fileURL.path
  }
}
