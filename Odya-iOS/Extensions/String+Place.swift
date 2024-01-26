//
//  String+Place.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/25.
//

import Foundation
import GooglePlaces

extension String {
  func placeIdToName(completion: @escaping (String) -> Void) {
    if self.isEmpty {
      completion("")
      return
    }
    
    let placeClient = GMSPlacesClient()
    let field: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue))
    
    Task {
      do {
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
          placeClient.fetchPlace(fromPlaceID: self, placeFields: field, sessionToken: nil) { place, error in
            if let error = error {
              continuation.resume(throwing: error)
            } else {
              continuation.resume(returning: place?.name ?? "")
            }
          }
        }
        completion(result)
      } catch {
        completion("")
      }
    }
  }
}
