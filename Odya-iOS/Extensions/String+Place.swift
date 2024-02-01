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
  
  func placeIdToAddress(completion: @escaping (String) -> Void) {
    if self.isEmpty {
      completion("")
      return
    }
    
    let placeClient = GMSPlacesClient()
    let field: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.formattedAddress.rawValue))

    Task {
      do {
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
          placeClient.fetchPlace(fromPlaceID: self, placeFields: field, sessionToken: nil) { place, error in
            if let error = error {
              continuation.resume(throwing: error)
            } else {
              continuation.resume(returning: place?.formattedAddress ?? "")
            }
          }
        }
        completion(result)
      } catch {
        completion("")
      }
    }
  }
  
  func placeIdToCoordinate(completion: @escaping (CLLocationCoordinate2D) -> Void) {
    let currentLocation = LocationManager.shared.fetchCurrentLocation().coordinate
    if self.isEmpty {
      completion(currentLocation)
    }
    
    let placeClient = GMSPlacesClient()
    let field: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))
    
    Task {
      do {
        let result = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) in
          placeClient.fetchPlace(fromPlaceID: self, placeFields: field, sessionToken: nil) { place, error in
            if let error = error {
              continuation.resume(throwing: error)
            } else {
              continuation.resume(returning: place?.coordinate ?? currentLocation)
            }
          }
        }
        completion(result)
      } catch {
        completion(currentLocation)
      }
    }
  }
}
