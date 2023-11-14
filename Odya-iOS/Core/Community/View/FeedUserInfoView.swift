//
//  FeedUserInfoView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedUserInfoView: View {
  // MARK: Properties

  let profileImageSize: ComponentSizeType
  let writer: Writer
  let createDate: String

  // MARK: Init

  init(profileImageSize: ComponentSizeType, writer: Writer, createDate: String) {
    self.profileImageSize = profileImageSize
    self.writer = writer
    self.createDate = createDate
  }

  // MARK: Body

  var body: some View {
    HStack(spacing: 12) {
      // 유저 프로필
      ProfileImageView(of: writer.nickname, profileData: writer.profile, size: profileImageSize)
      
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
        
        // date
        Text(createDate.toCustomRelativeDateString())
          .detail1Style()
          .foregroundColor(Color.odya.label.assistive)
      }
    }
  }
}
