//
//  RootTabView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct RootTabView: View {

  // MARK: Body

  var body: some View {
    TabView {
      // MARK: 홈
      HomeView()
        .tabItem {
          GNBButton(iconImage: "location-m", text: "홈")
        }

      // MARK: 내추억
      MyJournalsView()
        .tabItem {
          GNBButton(iconImage: "diary", text: "내추억")
        }

      // MARK: 피드
      FeedView()
        .tabItem {
          GNBButton(iconImage: "messages-off", text: "피드")
        }

      // MARK: 내정보
      ProfileView()
        .tabItem {
          GNBButton(iconImage: "person-off", text: "내정보")
        }
    }.accentColor(.odya.brand.primary)
  }
}

struct RootTabView_Previews: PreviewProvider {
  static var previews: some View {
    RootTabView()
  }
}
