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
    
    // MARK: Init
    
    init(profileImageSize: CGFloat) {
        self.profileImageSize = profileImageSize
    }
    
    // MARK: Body
    
    var body: some View {
      HStack(spacing: 12) {
            // 유저 프로필
            Image("profile")
              .resizable()
              .frame(
                width: profileImageSize,
                height: profileImageSize)
            
            HStack(spacing: 4) {
              // 유저 닉네임
              Text("닉네임")
                .b1Style()
                .foregroundColor(Color.odya.label.normal)

              // sparkle-s
              Image("sparkle-s")

              // dot
              Text("·")
                .detail1Style()
                .foregroundColor(Color.odya.label.assistive)

              // 상대 날짜
              Text("2일전")
                .detail1Style()
                .foregroundColor(Color.odya.label.assistive)
            }
        }
    }
}

// MARK: - Preview

struct FeedUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FeedUserInfoView(profileImageSize: ComponentSizeType.S.ProfileImageSize)
    }
}
