//
//  FavoritePlaceRow.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/13.
//

import SwiftUI

struct FavoritePlaceRow: View {
  var body: some View {
    HStack(spacing: 8) {
      Image("location-m")
        .renderingMode(.template)
      
      VStack(alignment: .leading, spacing: 8) {
        Text("해운대 해수욕장")
          .b1Style()
          .foregroundColor(.odya.label.normal)
          .frame(height: 12)
        Text("부산 해운대구")
          .b2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 12)
      }
        
      
      Spacer()
      
      StarButton(isActive: true, isYellowWhenActive: true) {}
    }
    .frame(height: 32)
  }
}

struct FavoritePlaceRow_Previews: PreviewProvider {
  static var previews: some View {
    FavoritePlaceRow()
  }
}
