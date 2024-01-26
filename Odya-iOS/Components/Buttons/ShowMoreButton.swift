//
//  ShowMoreButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/24.
//

import SwiftUI

extension View {
  func ShowMoreButton(labelText: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      HStack(spacing: 10) {
        Text(labelText)
          .detail1Style()
          .foregroundColor(Color.odya.label.assistive)
        Image("more-off")
          .renderingMode(.template)
          .foregroundColor(.odya.label.assistive)
      }
      .padding(.vertical, 8)
      .frame(height: 36)
      .frame(maxWidth: .infinity)
      .background(Color.odya.elevation.elev3)
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .inset(by: 0.5)
          .stroke(Color.odya.line.alternative, lineWidth: 1)
      )
    }
  }
}
