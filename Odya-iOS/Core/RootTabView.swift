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
                    GNBButton(iconImage: "location-m", text: "홈")
//                    Image(systemName: "house")
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
        }.accentColor(.odya.brand.primary)
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}
