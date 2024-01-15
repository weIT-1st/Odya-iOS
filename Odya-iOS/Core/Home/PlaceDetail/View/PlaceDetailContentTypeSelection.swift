//
//  PlaceDetailContentTypeSelection.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/08.
//

import SwiftUI

struct PlaceDetailContentTypeSelection: View {
  let contentType: PlaceDetailContentType
  @Binding var destination: PlaceDetailContentType
  @Binding var isDestinationChanged: Bool

  var body: some View {
    ZStack(alignment: .center) {
      GeometryReader { proxy in
        RoundedRectangle(cornerRadius: 50)
          .fill(Color.odya.brand.primary)
          .frame(height: 36)
          .frame(maxWidth: proxy.size.width / 3)
          .offset(x: contentType == .journal ? 0 : contentType == .review ? proxy.size.width / 3 - 4 : proxy.size.width / 3 * 2 - 4)
          .padding(2)
      } // GeometryReader
      
      HStack(spacing: 0) {
        ForEach(PlaceDetailContentType.allCases, id: \.self) { type in
          VStack {
            Text(type.title)
              .b1Style()
              .foregroundColor(contentType == type ? .odya.label.r_normal : .odya.label.inactive)
          }
          .frame(height: 36)
          .frame(maxWidth: .infinity)
          .onTapGesture {
            destination = type
            isDestinationChanged.toggle()
          }
        }
      } // HStack
      
    } // ZStack
    .background(
      RoundedRectangle(cornerRadius: 50)
        .foregroundColor(.odya.elevation.elev5)
    )
    .frame(height: 40)
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 40)
  }
}

struct PlaceDetailContentTypeSelection_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailContentTypeSelection(contentType: .review, destination: .constant(.community), isDestinationChanged: .constant(false))
  }
}
