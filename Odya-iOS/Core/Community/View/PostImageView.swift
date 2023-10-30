//
//  PostImageView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct PostImageView: View {
  // MARK: Properties
  let urlString: String
    
  // MARK: - Body

  var body: some View {
    ZStack {
      // image
        AsyncImage(
              url: URL(string: urlString)!,
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

      // default image
//      Image("logo-rect")

      // 여행일지 연동
      HStack {

      }
    }
//    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
    .clipShape(RoundedEdgeShape(edgeType: .top))
  }
}
