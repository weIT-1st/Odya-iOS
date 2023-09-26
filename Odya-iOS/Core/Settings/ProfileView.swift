//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileVM : ProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 24) {
                    topNavigationBar
                    
                    Circle().frame(width: 96, height: 96)
                    Text(profileVM.nickname)
                        .h3Style()
                    
                    followTotal
                }
                .padding(.horizontal, GridLayout.side)
                .background(
                    bgImage.offset(y: -70)
                )
                Spacer()
            }.background(Color.odya.background.normal)
        }
        .onAppear {
            Task.init {
                await profileVM.fetchDataAsync()
            }
        }
    }
    
    private var topNavigationBar: some View {
        HStack(spacing: 8) {
            Spacer()
            IconButton("pen-s") {}
            NavigationLink(
                destination: SettingView()
                    .navigationBarHidden(true)
            ) {
                Image("setting")
                    .padding(10)
            }
        }
    }
    
    private var bgImage: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(.black.opacity(0.5))
            .background(
                Color.odya.brand.primary
            )
            .blur(radius: 8)
    }
    
    private var followTotal: some View {
        NavigationLink(
            destination: FollowHubView(token: profileVM.idToken, userID: profileVM.userID ?? -1, followCount: profileVM.followCount)
                .navigationBarHidden(true)
        ) {
            HStack(spacing: 20) {
                Spacer()
                VStack {
                    Text("총오댜")
                        .b1Style().foregroundColor(.odya.label.alternative)
                    Text("119")
                        .h4Style().foregroundColor(.odya.label.normal)
                }
                Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
                VStack {
                    Text("팔로잉")
                        .b1Style().foregroundColor(.odya.label.alternative)
                    Text("\(profileVM.followCount.followingCount)")
                        .h4Style().foregroundColor(.odya.label.normal)
                }
                Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
                VStack {
                    Text("팔로우")
                        .b1Style().foregroundColor(.odya.label.alternative)
                    Text("\(profileVM.followCount.followerCount)")
                        .h4Style().foregroundColor(.odya.label.normal)
                }
                Spacer()
            }
            .frame(width: .infinity, height: 80)
            .background(Color.odya.whiteopacity.baseWhiteAlpha20)
            .cornerRadius(Radius.large)
            .overlay (
                RoundedRectangle(cornerRadius: Radius.large)
                    .inset(by: 0.5)
                    .stroke(Color.odya.line.alternative, lineWidth: 1)
            )
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
