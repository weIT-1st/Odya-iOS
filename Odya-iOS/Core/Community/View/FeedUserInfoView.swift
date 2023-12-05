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
    HStack(spacing: 4) {
      // user info
      UserIdentityLink(userId: writer.userID,
                       nickname: writer.nickname,
                       profileUrl: writer.profile.profileUrl,
                       profileSize: profileImageSize,
                       isFollowing: writer.isFollowing)
      
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
