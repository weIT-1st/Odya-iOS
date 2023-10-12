//
//  RootTabView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct RootTabView: View {

  // MARK: Body
    @ObservedObject var profileVM: ProfileViewModel
    
    init(token: String) {
        profileVM = ProfileViewModel(idToken: token)
    }

  var body: some View {
    TabView {
      // MARK: 홈
      HomeView()
        .tabItem {
          GNBButton(iconImage: "location-m", text: "홈")
        }

      // MARK: 내추억
      MyJournalsView()  // 임시
        .tabItem {
          GNBButton(iconImage: "diary", text: "내추억")
        }
        .environmentObject(profileVM)

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
        .environmentObject(profileVM)
    }.accentColor(.odya.brand.primary)
  }
}

struct RootTabView_Previews: PreviewProvider {
  static var previews: some View {
    RootTabView(token: "testIdToken")
  }
}
