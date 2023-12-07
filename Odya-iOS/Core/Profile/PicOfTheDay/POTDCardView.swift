//
//  POTDCardView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/06.
//

import SwiftUI

struct POTDCardView: View {
  let imageUrl: String = ""
  let place: String = "해운대해수욕장"
  
  var body: some View {
    VStack(spacing: 20) {
      Rectangle()
        .foregroundColor(.odya.brand.primary)
        .frame(width: 223, height: 223)
        .cornerRadius(Radius.medium)
      
      HStack(spacing: 8) {
        Image("location-s")
          .renderingMode(.template)
        Text(place)
          .b2Style()
        Spacer()
      }
      .foregroundColor(.odya.label.assistive)
      .frame(width: 223)
    }
  }
}

struct POTDCardView_Previews: PreviewProvider {
  static var previews: some View {
    POTDCardView()
  }
}

