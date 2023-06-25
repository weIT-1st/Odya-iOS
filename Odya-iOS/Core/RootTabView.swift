//
//  RootTabView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                }
            // 메인 홈
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            // 내 정보
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
