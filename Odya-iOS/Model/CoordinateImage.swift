//
//  CoordinateImage.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/26.
//

import Foundation
import GoogleMaps

// MARK: - CoordinateImage
struct CoordinateImage: Decodable {
  let imageId: Int
  let userId: Int
  let imageUrl: String
  let placeId: String?
  let latitude: Double
  let longitude: Double
  let imageUserType: ImageUserType
  let journalId: Int?
  let communityId: Int?
  
  var marker: GMSMarker {
    let temp = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    temp.iconView = CustomMarkerIconView(frame: .zero, urlString: imageUrl, sparkle: .small)
    temp.userData = placeId
    return temp
  }
}

enum ImageUserType: String, Decodable {
  case user = "USER"
  case friend = "FRIEND"
  case other = "OTHER"
  
  func getNext() -> Self {
    switch self {
    case .user:
      return .friend
    case .friend:
      return .user
    case .other:
      return .other
    }
  }
}

enum SparkleMapMarker {
  case small
  case medium
  case large
  
  var imageName: String {
    switch self {
    case .small:
      return "sparkle-filled-s"
    case .medium:
      return "sparkle-filled-m"
    case .large:
      return "sparkle-filled-l"
    }
  }
}
