//
//  PlaceNameTextView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/26.
//

import SwiftUI

/// placeId를 placeName으로 변환한 텍스트 뷰
struct PlaceNameTextView: View {
  @State var placeId: String?
  @State private var placeName: String = ""
  
  init(placeId: String?) {
    self._placeId = State(initialValue: placeId)
  }
  
  var body: some View {
    Text(placeName)
      .task {
        placeId?.placeIdToName {
          placeName = $0
        }
      }
  }
}

struct PlaceAddressTextView: View {
  @State var placeId: String?
  @State private var placeAddress: String = ""
  
  init(placeId: String?) {
    self._placeId = State(initialValue: placeId)
  }
  
  var body: some View {
    Text(placeAddress)
      .lineLimit(1)
      .truncationMode(.tail)
      .task {
        placeId?.placeIdToAddress {
          placeAddress = $0
        }
      }
  }
}
