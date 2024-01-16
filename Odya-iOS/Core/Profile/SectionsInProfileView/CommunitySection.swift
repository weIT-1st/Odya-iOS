//
//  CommunitySection.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/14.
//

import SwiftUI

extension ProfileView {
  var linkToMyCommunity: some View {
    Button(action: {
      path.append(ProfileRoute.myCommunity)
    }) {
      HStack(alignment: .center) {
        Text("내 커뮤니티 활동")
          .h5Style()
          .foregroundColor(.odya.label.normal)
        Spacer()

        Image("direction-right")
          .padding(10)
      }
    }
  }
}
