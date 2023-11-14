//
//  Community.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/12.
//

import Foundation

enum FeedSortType: String {
  case lastest = "LATEST"
  case like = "LIKE"
}

// MARK: - Feed
struct Feed: Codable {
  let hasNext: Bool
  let content: [FeedContent]
}

struct FeedContent: Codable, Equatable {
  let communityID: Int
  let communityContent: String
  let communityMainImageURL: String
  //    let placeID
  let writer: Writer
  //    let travelJournalSimpleResponse
  let communityCommentCount, communityLikeCount: Int
  let createdDate: String

  enum CodingKeys: String, CodingKey {
    case communityID = "communityId"
    case communityContent
    case communityMainImageURL = "communityMainImageUrl"
    case writer, communityCommentCount, communityLikeCount, createdDate
    //        case placeID = "placeId"
    //        case travelJournalSimpleResponse
  }

  static func == (lhs: FeedContent, rhs: FeedContent) -> Bool {
    return lhs.communityID == rhs.communityID
  }
}

struct Writer: Codable {
  let userID: Int
  let nickname: String
  let profile: ProfileData
  let isFollowing: Bool?

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case nickname, profile, isFollowing
  }
}

// MARK: - FeedDetail
struct FeedDetail: Codable {
  let communityID: Int
  let content, visibility: String
  let placeID: String?
  let writer: Writer
  let travelJournal: LinkedTravelJournal?
  let topic: FeedDetailTopic?
  let communityContentImages: [CommunityContentImage]
  let communityCommentCount, communityLikeCount: Int
  let isUserLiked: Bool
  let createdDate: String

    enum CodingKeys: String, CodingKey {
        case communityID = "communityId"
        case content, visibility
        case placeID = "placeId"
        case writer, travelJournal, topic, communityContentImages, communityCommentCount, communityLikeCount, isUserLiked, createdDate
    }
}

struct CommunityContentImage: Codable {
  let communityContentImageID: Int
  let imageURL: String

  enum CodingKeys: String, CodingKey {
    case communityContentImageID = "communityContentImageId"
    case imageURL = "imageUrl"
  }
}

struct LinkedTravelJournal: Codable {
  let travelJournalID: Int
  let title, mainImageURL: String

  enum CodingKeys: String, CodingKey {
    case travelJournalID = "travelJournalId"
    case title
    case mainImageURL = "mainImageUrl"
  }
}
