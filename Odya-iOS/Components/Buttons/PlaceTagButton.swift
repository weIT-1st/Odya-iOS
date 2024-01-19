//
//  PlaceTagButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/18.
//

import SwiftUI

extension View {
  func PlaceTagButtonWithAction(placeName: String?, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      HStack(spacing: 12) {
        Image("location-m")
          .colorMultiply(.odya.label.assistive)
        Text(placeName ?? "장소 태그하기")
          .b1Style()
          .foregroundColor(placeName == nil ? .odya.label.assistive : .odya.label.normal)
        Spacer()
      }
      .padding(12)
      .frame(height: 48)
      .background(Color.odya.elevation.elev4)
      .cornerRadius(Radius.medium)
      .overlay(
        RoundedRectangle(cornerRadius: Radius.medium)
          .inset(by: 0.5)
          .stroke(Color.odya.line.alternative, lineWidth: 1)
      )
    }
  }
}

struct PlaceTagButton: View {
  let placeName: String?
  
  var body: some View {
    HStack(spacing: 12) {
      Image("location-m")
        .colorMultiply(.odya.label.assistive)
      Text(placeName ?? "장소 태그하기")
        .b1Style()
        .foregroundColor(placeName == nil ? .odya.label.assistive : .odya.label.normal)
      Spacer()
    }
    .padding(12)
    .frame(height: 48)
    .background(Color.odya.elevation.elev4)
    .cornerRadius(Radius.medium)
    .overlay(
      RoundedRectangle(cornerRadius: Radius.medium)
        .inset(by: 0.5)
        .stroke(Color.odya.line.alternative, lineWidth: 1)
    )
  }
}
