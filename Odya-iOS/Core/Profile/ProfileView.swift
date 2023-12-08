//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct ProfileView: View {
  @StateObject var profileVM = ProfileViewModel()
  @StateObject var followButtonVM = FollowButtonViewModel()
  
  @Environment(\.dismiss) var dismiss
  
  var userId: Int = -1
  var nickname: String =  ""
  var profileUrl: String = ""
  var isFollowing: Bool? = nil
  
  var isMyProfile: Bool {
    profileVM.userID == MyData.userID
  }
  
  init() {}
  
  init(userId: Int, nickname: String, profileUrl: String, isFollowing: Bool? = nil) {
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.isFollowing = isFollowing
  }
  
  // MARK: Body
  
  var body: some View {
    NavigationView {
      ScrollView(.vertical) {
        VStack(spacing: 24) {
          topNavigationBar
          Group {
            profileImgAndNickname
            followTotal
          }.padding(.horizontal, GridLayout.side)
        }.background(
          bgImage.offset(y: -70)
        )
        
        VStack(spacing: 20) {
          odyaCounter
            .padding(.horizontal, GridLayout.side)
          
          VStack(spacing: 36) {
            POTDTitle
              .padding(.horizontal, GridLayout.side)
            POTDList
              .padding(.leading, GridLayout.side)
          }
          
          Divider().frame(height: 8).background(Color.odya.blackopacity.baseBlackAlpha70)
          
          
          Spacer()
        }
        .padding(.top, 20)
      }
      .background(Color.odya.background.normal)
      .onAppear {
        if userId > 0 {
          profileVM.initData(userId, nickname, profileUrl)
        } else {
          let myData = MyData()
          profileVM.initData(MyData.userID, myData.nickname, myData.profile.decodeToProileData().profileUrl)
        }
        
        Task {
          await profileVM.fetchDataAsync()
        }
      }
    }
  }
}
  
  // MARK: Navigation Bar
extension ProfileView {
  private var topNavigationBar: some View {
    HStack(spacing: 0) {
      if isMyProfile {
        Spacer()
        NavigationLink(
          destination: SettingView()
            .navigationBarHidden(true)
        ) {
          Image("setting")
            .padding(10)
        }
      } else {
        IconButton("direction-left") {
          dismiss()
        }
        Spacer()
      }
    }
    .padding(.horizontal, 8)
    .frame(height: 56)
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
