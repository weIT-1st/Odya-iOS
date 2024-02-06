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
  let simpleTravelJournal: TravelJournalSimpleResponse?

  // MARK: - Body

  var body: some View {
    ZStack(alignment: .bottom) {
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
            .frame(
              width: UIScreen.main.bounds.width,
              height: UIScreen.main.bounds.width
            )
        }
      )

      // 여행일지 연동
      if let journal = simpleTravelJournal {
        HStack {
          Image("diary")
            .frame(width: 24, height: 24)
          Text(journal.title)
            .detail1Style()
            .foregroundColor(.odya.label.normal)
          Spacer()
          Image("direction-right")
        }
        .padding(.leading, 17)
        .padding(.trailing, 13)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Color.odya.background.dimmed_system)
        .clipShape(RoundedEdgeShape(edgeType: .top))
      }
    }
    .clipShape(RoundedEdgeShape(edgeType: .top))
  }
}
