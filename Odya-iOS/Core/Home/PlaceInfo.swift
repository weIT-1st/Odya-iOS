//
//  PlaceInfo.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/08.
//

import GooglePlaces
import SwiftUI

final class PlaceInfo: ObservableObject {
  @Published var title: String = ""
  @Published var address: String = ""
  var placeId: String = ""
  var sessionToken: GMSAutocompleteSessionToken?
  
  func setValue(title: String, address: String, placeId: String, token: GMSAutocompleteSessionToken?) {
    self.title = title
    self.address = address
    self.placeId = placeId
    self.sessionToken = token
  }
  
  func setValue(placeId: String) {
    self.placeId = placeId
    self.sessionToken = nil
    self.title = ""
    self.address = ""
    placeId.placeIdToName { name in
      DispatchQueue.main.async {
        self.title = name
      }
    }
    placeId.placeIdToAddress { address in
      DispatchQueue.main.async {
        self.address = address
      }
    }
  }
}
