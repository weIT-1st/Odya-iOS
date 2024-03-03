//
//  RootTabView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct RootTabView: View {

//  @EnvironmentObject var alertManager: AlertManager
  @EnvironmentObject var appState: AppState
  // @StateObject var fullScreenManager = FullScreenCoverManager()
  
  // MARK: Body

  var body: some View {
    TabView(selection: $appState.activeTab) {
      // MARK: 홈
      HomeView()
        .environmentObject(appState)
        .tabItem {
          GNBButton(iconImage: Tab.home.symbolImage, text: Tab.home.title)
        }.tag(Tab.home)

      // MARK: 내추억
      MyJournalsView()
        .environmentObject(appState)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: Tab.journal.symbolImage, text: Tab.journal.title)
        }.tag(Tab.journal)

      // MARK: 피드
      FeedView()
        .environmentObject(appState)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: Tab.feed.symbolImage, text: Tab.feed.title)
        }.tag(Tab.feed)

      // MARK: 내정보
      ProfileView()
        .environmentObject(appState)
        // .environmentObject(fullScreenManager)
        .tabItem {
          GNBButton(iconImage: Tab.profile.symbolImage, text: Tab.profile.title)
        }.tag(Tab.profile)
    }.accentColor(.odya.brand.primary)
  }
}

struct RootTabView_Previews: PreviewProvider {
  static var previews: some View {
    RootTabView()
  }
}
