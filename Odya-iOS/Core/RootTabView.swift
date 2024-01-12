//
//  RootTabView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

class RootTabManager: ObservableObject {
  @Published var selectedTab: Int = 0
}

struct RootTabView: View {

  @StateObject var rootTabManager = RootTabManager()
  // @StateObject var fullScreenManager = FullScreenCoverManager()
  
  // MARK: Body

  var body: some View {
    TabView(selection: $rootTabManager.selectedTab) {
      // MARK: 홈
      HomeView()
        .tabItem {
          GNBButton(iconImage: "location-m", text: "홈")
        }.tag(0)

      // MARK: 내추억
      MyJournalsView()
        .environmentObject(rootTabManager)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: "diary", text: "내추억")
        }.tag(1)

      // MARK: 피드
      FeedView()
        .environmentObject(rootTabManager)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: "messages-off", text: "피드")
        }.tag(2)

      // MARK: 내정보
      ProfileView()
        .environmentObject(rootTabManager)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: "person-off", text: "내정보")
        }.tag(3)
    }.accentColor(.odya.brand.primary)
  }
}

struct RootTabView_Previews: PreviewProvider {
  static var previews: some View {
    RootTabView()
  }
}
