//
//  SettingView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/08.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
//        NavigationView {
            VStack {
                CustomNavigationBar(title: "환경설정")
                settingViewMainSection
            }.background(Color.odya.background.normal)
//        }.ignoresSafeArea()
    } // body
    
    var settingViewMainSection: some View {
        ScrollView {
            VStack(spacing: 12) {
                linkToUserInfoEditView
                Divider()
                
            } // Main VStack
            .padding(GridLayout.side)
        } // Scroll View
        .background(Color.odya.elevation.elev2)
    } // settingViewMainSection
    
    var linkToUserInfoEditView: some View {
        NavigationLink(destination: {
            UserInfoEditView()
                .navigationBarHidden(true)
        }, label: {
            HStack {
                Text("회원정보 수정")
                    .b1Style().foregroundColor(.odya.label.normal)
                Spacer()
                Image("direction-right")
            }
        })
    } // linkToUserInfoEditView
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
