//
//  PostImageView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct PostImageView: View {
  // MARK: - Body

  var body: some View {
    ZStack {
      // image

      // default image
      Image("logo-rect")

      // 여행일지 연동
      HStack {

      }
    }
    .frame(width: UIScreen.main.bounds.width, height: 284, alignment: .center)
    .clipShape(RoundedEdgeShape(edgeType: .top))
  }
}

// MARK: - Preview

struct PostImage_Previews: PreviewProvider {
  static var previews: some View {
    PostImageView()
  }
}
