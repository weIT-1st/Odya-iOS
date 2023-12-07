//
//  UserImage.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/08.
//

import SwiftUI

/// 사용자가 여행일지 및 피드에 올린 사진
struct UserImage: Codable, Identifiable {
  let id = UUID()
  var imageId: Int
  var imageUrl: String
  var placeId: String?
  var isLifeShot: Bool
  var placeName: String?
  var journalId: Int?
  var communityId: Int?
  
  enum CodingKeys: String, CodingKey {
    case imageId, imageUrl, placeId, isLifeShot, placeName, journalId, communityId
  }
}

struct UserImagesResponse: Codable {
  var hasNext: Bool
  var content: [UserImage]
}
