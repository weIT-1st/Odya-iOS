//
//  SquareAsyncImage.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/20.
//

import SwiftUI

/// 정사각형 URL String-> 이미지 뷰
struct SquareAsyncImage: View {
  let url: String

  var body: some View {
    AsyncImage(
      url: URL(string: url)!,
      content: { image in
        image.resizable()
          .aspectRatio(contentMode: .fill)
          .frame(
            // 화면 너비와 같음
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width
          )
          .clipped()
      },
      placeholder: {
        ProgressView()
      }
    )
  }
}
