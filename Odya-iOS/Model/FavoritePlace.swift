//
//  FavoritePlace.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct FavoritePlace: Codable, Identifiable {
  let id = UUID()
  var placeId: Int
  var placeIdString: String
  var userId: Int
  var isFavoritePlace: Bool
  
  enum CodingKeys: String, CodingKey {
    case placeId = "id"
    case placeIdString = "placeId"
    case userId, isFavoritePlace
  }
}

struct FavoritePlacesResponse: Codable {
  var hasNext: Bool
  var content: [FavoritePlace]
}