//
//  FollowListView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/10.
//

import SwiftUI

struct FollowUserView: View {
  let userData: FollowUserData
  private let status: ProfileImageStatus

  init(user: FollowUserData) {
    self.userData = user
    if let profileUrl = user.profileData.profileUrl {
      self.status = .withImage(url: URL(string: profileUrl)!)
    } else {
      self.status = .withoutImage(
        colorHex: user.profileData.profileColor.colorHex ?? "#FFD41F", name: user.nickname)
    }
  }

  var body: some View {
    NavigationLink(destination: UserProfileView(userData: userData)) {
      HStack(spacing: 0) {
        ProfileImageView(status: status, sizeType: .S)
          .padding(.trailing, 12)
        Text(userData.nickname)
          .foregroundColor(.odya.label.normal)
          .b1Style()
          .padding(.trailing, 4)
        Image("sparkle-s")
      }
    }
  }
}

struct FollowingUserRowView: View {
    var userData: FollowUserData
    @State var followState: Bool
    
    var body: some View {
        HStack {
            FollowUserView(user: userData)
            Spacer()
            FollowButton(isFollowing: followState, buttonStyle: .solid) {
                followState.toggle()
            }
            .animation(.default, value: followState)
        }
        .frame(height: 36)
    }
}

struct FollowerUserRowView: View {
    var userData: FollowUserData
    
    var body: some View {
        HStack {
            FollowUserView(user: userData)
            Spacer()
        }
        .frame(height: 36)
    }
}

struct FollowUserListView: View {
    var followType: FollowType
    @Binding var displayedUsers: [FollowUser]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(displayedUsers) { user in
                    switch followType {
                    case .following:
                        FollowingUserRowView(userData: user.userData, followState: user.followState)
                    case .follower:
                        FollowerUserRowView(userData: user.userData)
                    }
                }
            }
            .padding(.horizontal, GridLayout.side)
        }
    }
}

struct FollowSearchBar: View {
    var promptText: String
    @State var nameToSearch: String = ""
    
    var body: some View {
        HStack {
          TextField(
            nameToSearch, text: $nameToSearch,
            prompt: Text(promptText)
              .foregroundColor(.odya.label.inactive)
          )
          .b1Style()

          IconButton("search") {}
            .disabled(nameToSearch.count == 0)
        }
        .modifier(CustomFieldStyle(backgroundColor: Color.odya.elevation.elev4))
        .padding(.horizontal, GridLayout.side)

    }
}

struct FollowListView: View {
    @State private var followType: FollowType = .following
    @ObservedObject var followListVM: FollowListViewModel
    
    init(userID: String) {
        self.followListVM = FollowListViewModel(userID: userID)
    }
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "친구 관리")
            FollowSearchBar(promptText: "친구를 찾아보세요!")
            followTypeToggle
                .padding(.vertical, 20)
            FollowUserListView(followType: followType, displayedUsers: $followListVM.displayedUsers)
        }
        .onChange(of: followType) { newValue in
            followListVM.setDisplayedUsers(followType: newValue)
        }
        .onAppear {
            followListVM.setDisplayedUsers(followType: followType)
        }
        .background(Color.odya.background.normal)
    }
    
    private var followTypeToggle: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 190, height: 40)
                .foregroundColor(.odya.elevation.elev5)
            
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 91.7, height: 36)
                .foregroundColor(.odya.brand.primary)
                .offset(x: followType == .following ? 47.15 : -47.15)
                .animation(.easeInOut, value: followType)
            
            HStack(spacing: 2) {
                Button(action: {
                    followType = .follower
                }) {
                    Text("팔로워")
                        .b1Style()
                        .foregroundColor(.odya.label.inactive)
                        .padding(10)
                        .frame(width: 92)
                }
                Button(action: {
                    followType = .following
                }) {
                    Text("팔로잉")
                        .b1Style()
                        .foregroundColor(.odya.label.inactive)
                        .padding(10)
                        .frame(width: 92)
                }
            }.frame(height: 40)
        }
    }
}

struct FollowListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowListView(userID: "testIdToken")
    }
}
