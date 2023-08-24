//
//  FishchipsBar.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FishchipsBar: View {
  // MARK: - Body

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 8) {
        FishchipButton(
          isActive: .active, buttonStyle: .solid, imageName: nil, labelText: "전체 글보기", labelSize: .M
        ) {
          // action
        }

        FishchipButton(
          isActive: .active, buttonStyle: .ghost, imageName: nil, labelText: "친구글만 보기",
          labelSize: .M
        ) {
          // action
        }

        // TODO: fishchip 받아와서 동적으로 만들기

      }  // HStack
      .padding(.leading, 20)
      .frame(height: 48, alignment: .leading)
    }  // ScrollView
  }
}

// MARK: - Preview

struct FishchipsBar_Previews: PreviewProvider {
  static var previews: some View {
    FishchipsBar()
  }
}
