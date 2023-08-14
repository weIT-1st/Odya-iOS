//
//  SettingView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/08.
//

import SwiftUI


struct CustomNavigationBar: View {
    @Environment(\.presentationMode) private var presentationMode
    let title: String
    
    var body: some View {
        HStack {
            IconButton("direction-left") {
                presentationMode.wrappedValue.dismiss() // 뒤로 이동 기능 수행
            }
            Spacer()
            Text(title)
                .h6Style()
                .foregroundColor(.odya.label.normal)
            Spacer()
            IconButton("direction-right") {}.disabled(true)
                .colorMultiply(.odya.background.normal)
        }
        .padding(.horizontal, 8)
    }
}

struct SettingView: View {
    var body: some View {
        NavigationView {
            VStack {
                CustomNavigationBar(title: "환경설정")
                settingViewMainSection
            }.background(Color.odya.background.normal)
        }.ignoresSafeArea()
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
            UserInfoEditView(userInfo: UserInfo(nickname: "길동아밥먹자"))
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
