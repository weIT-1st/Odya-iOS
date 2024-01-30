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
    temp.iconView = CustomMarkerIconView(frame: .zero, urlString: imageUrl)
    return temp
  }
}

enum ImageUserType: String, Decodable {
  case user = "USER"
  case friend = "FRIEND"
  case other = "OTHER"
}
