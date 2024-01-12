//
//  FavoritePlaceRow.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct FavoritePlaceRow: View {
  @EnvironmentObject var VM: FavoritePlaceInProfileViewModel
  @StateObject var bookmarkManager = FavoritePlaceBookmark()

  let placeId: Int
  let placeIdString: String
  @State private var isBookmarked: Bool

  init(favoritePlace: FavoritePlace) {
    self.placeId = favoritePlace.placeId
    self.placeIdString = favoritePlace.placeIdString
    self._isBookmarked = State(initialValue: favoritePlace.isFavoritePlace)
  }

  var body: some View {
    HStack(spacing: 8) {
      Image("location-m")
        .renderingMode(.template)

      VStack(alignment: .leading, spacing: 8) {
        Text("\(placeIdString)")
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .frame(height: 12)
        Text("부산 해운대구")
          .b2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 12)
      }

      Spacer()

      StarButton(isActive: isBookmarked, isYellowWhenActive: true) {
        bookmarkManager.setBookmarkState(isBookmarked, placeIdString, placeId) { result in
          isBookmarked = result
          VM.updateFavoritePlaces()
        }
      }
    }
    .frame(height: 32)
  }
}
//
//struct FavoritePlaceRow_Previews: PreviewProvider {
//  static var previews: some View {
//    FavoritePlaceRow()
//  }
//}
