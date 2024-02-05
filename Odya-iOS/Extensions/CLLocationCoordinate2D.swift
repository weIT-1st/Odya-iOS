//
//  CLLocationCoordinate2D.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/31.
//

import CoreLocation

extension CLLocationCoordinate2D {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    if lhs.latitude == rhs.latitude && lhs.longitude == lhs.longitude {
      return true
    } else {
      return false
    }
  }
  
  /// 같은 좌표가 존재할 경우 마이너한 변화주기
  mutating func variateForEqual(coordinates: [CLLocationCoordinate2D]) {
    var variatedLatitude = latitude
    var variatedLongitude = longitude
    
    let filteredPositions = coordinates.filter {
      $0 == self
    }
    
    if !filteredPositions.isEmpty {
      let variation = Double.random(in: -0.01...0.01) / 1500
      variatedLatitude = latitude + variation
      variatedLongitude = longitude + variation
      self = CLLocationCoordinate2D(latitude: variatedLatitude, longitude: variatedLongitude)
    } else {
      return
    }
  }
}
