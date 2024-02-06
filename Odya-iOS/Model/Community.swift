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
  let communityId: Int
  let communityContent: String
  let communityMainImageURL: String
  let placeId: String?
  let writer: Writer
  let travelJournalSimpleResponse: TravelJournalSimpleResponse?
  let communityCommentCount, communityLikeCount: Int
  let isUserLiked: Bool
  let createdDate: String

  enum CodingKeys: String, CodingKey {
    case communityId
    case communityContent
    case communityMainImageURL = "communityMainImageUrl"
    case writer, communityCommentCount, communityLikeCount, createdDate
    case isUserLiked
    case placeId
    case travelJournalSimpleResponse
  }

  static func == (lhs: FeedContent, rhs: FeedContent) -> Bool {
    return lhs.communityId == rhs.communityId
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

struct TravelJournalSimpleResponse: Codable {
  let travelJournalId: Int
  let title: String
  let mainImageURL: String?
  
  enum CodingKeys: String, CodingKey {
    case travelJournalId, title
    case mainImageURL = "mainImageUrl"
  }
}

// MARK: - FeedDetail
struct FeedDetail: Codable {
  let communityId: Int
  let content, visibility: String
  let placeId: String?
  let writer: Writer
  let travelJournal: LinkedTravelJournal?
  let topic: FeedDetailTopic?
  let communityContentImages: [CommunityContentImage]
  let communityCommentCount, communityLikeCount: Int
  let isUserLiked: Bool
  let createdDate: String
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

// MARK: - MyCommunityList
struct MyCommunity: Codable {
  let hasNext: Bool
  let content: [MyCommunityContent]
}

struct MyCommunityContent: Codable {
  let communityID: Int
  let communityMainImageURL: String
  let placeID: String?

  enum CodingKeys: String, CodingKey {
    case communityID = "communityId"
    case communityMainImageURL = "communityMainImageUrl"
    case placeID = "placeId"
  }
}

// MARK: - MyCommunityComments
struct MyCommunityComments: Codable {
  let hasNext: Bool
  let content: [MyCommunityCommentsContent]
}

struct MyCommunityCommentsContent: Codable {
  let communityID: Int
  let communityContent, communityMainImageURL, updatedAt: String
  let writer: Writer
  let communityCommentSimpleResponse: CommunityCommentSimpleResponse

  enum CodingKeys: String, CodingKey {
    case communityID = "communityId"
    case communityContent
    case communityMainImageURL = "communityMainImageUrl"
    case updatedAt, writer, communityCommentSimpleResponse
  }
}

struct CommunityCommentSimpleResponse: Codable {
  let communityCommentID: Int
  let content, updatedAt: String
  let user: Writer

  enum CodingKeys: String, CodingKey {
    case communityCommentID = "communityCommentId"
    case content, updatedAt, user
  }
}
