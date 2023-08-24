//
//  FishchipButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/24.
//

import SwiftUI

extension View {
  func FishchipButton(
    isActive: ButtonActiveSate, buttonStyle: ButtonStyleType, imageName: String?, labelText: String,
    labelSize: ComponentSizeType, action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 8) {
        if let imageName = imageName {
          Image(imageName)
        }

        switch labelSize {
        case .M:
          Text(labelText)
            .b1Style()
        default:
          Text(labelText)
            .detail1Style()
        }
      }
      .frame(height: labelSize.FishchipButtonHeight)
      .padding(.vertical, 4)
      .padding(.horizontal, 12)
    }
    .buttonStyle(CustomButtonStyle(cornerRadius: 20, state: isActive, style: buttonStyle))
  }
}
