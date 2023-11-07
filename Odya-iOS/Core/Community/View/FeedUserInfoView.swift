//
//  FeedUserInfoView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedUserInfoView: View {
  // MARK: Properties

  let profileImageSize: CGFloat
  let writer: Writer
  let createDate: String

  // MARK: Init

  init(profileImageSize: CGFloat, writer: Writer, createDate: String) {
    self.profileImageSize = profileImageSize
    self.writer = writer
    self.createDate = createDate
  }

  // MARK: Body

  var body: some View {
    HStack(spacing: 12) {
      // 유저 프로필
      AsyncImage(
        url: URL(string: writer.profile.profileUrl),
        content: { image in
          image.resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.init(hex: writer.profile.profileColor?.colorHex ?? "#FFFFFF"))
            .clipShape(Circle())
            .frame(width: profileImageSize, height: profileImageSize)
        },
        placeholder: {
          Image("profile")
            .frame(width: profileImageSize, height: profileImageSize)
        }
      )

      HStack(spacing: 4) {
        // 유저 닉네임
        Text(writer.nickname)
          .b1Style()
          .foregroundColor(Color.odya.label.normal)

        // sparkle-s
        Image("sparkle-s")

        // dot
        Text("·")
          .detail1Style()
          .foregroundColor(Color.odya.label.assistive)

        // TODO: 상대 날짜
        Text(createDate.toOdyaRelativeDateString())
          .detail1Style()
          .foregroundColor(Color.odya.label.assistive)
      }
    }
  }
}
