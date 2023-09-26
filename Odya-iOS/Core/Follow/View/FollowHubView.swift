//
//  FollowHubView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/10.
//

import SwiftUI

// MARK: Follow Search Bar

/// 팔로워/팔로잉 닉네임 검색창
struct FollowSearchBar: View {
  var promptText: String
  @EnvironmentObject var followHubVM: FollowHubViewModel

  @State private var input: String = ""
  @Binding var nameToSearch: String
  @Binding var searchResultsDisplayed: Bool

  var body: some View {
    HStack {
      TextField(
        input, text: $input,
        prompt: Text(promptText)
          .foregroundColor(.odya.label.inactive)
      )
      .foregroundColor(input != nameToSearch ? .odya.label.normal : .odya.label.inactive)
      .b1Style()

      if input != "" {
        IconButton("smallGreyButton-x-filled") {
          input = ""
          nameToSearch = ""
          searchResultsDisplayed = false
        }
      }
      IconButton("search") {
        nameToSearch = input
        searchResultsDisplayed = true
      }.disabled(input.count == 0 || input == nameToSearch)
    }
    .modifier(CustomFieldStyle(backgroundColor: Color.odya.elevation.elev4))
    .padding(.horizontal, GridLayout.side)
    .onChange(of: input) { newValue in
      if newValue == "" {
        searchResultsDisplayed = false
      }
    }
  }
}

// MARK: Follow Hub View

/// 친구관리 뷰
/// 팔로워/팔로잉 리스트를 확인 할 수 있음
/// 알 수도 있는 친구 추천을 받을 수 있음
/// 닉네임을 통해 팔로워/팔로잉를 검색할 수 있음
struct FollowHubView: View {
  @ObservedObject var followHubVM: FollowHubViewModel
  @State var displayedUsers: [FollowUserData] = []
  @State var nameToSearch: String = ""
  @State var searchResultsDisplayed: Bool = false

  init(token: String, userID: Int, followCount: FollowCount) {
    self.followHubVM = FollowHubViewModel(token: token, userID: userID, followCount: followCount)
  }

  var body: some View {
    VStack {
      CustomNavigationBar(title: "친구 관리")
      FollowSearchBar(
        promptText: "친구를 찾아보세요!", nameToSearch: $nameToSearch,
        searchResultsDisplayed: $searchResultsDisplayed
      )
      .environmentObject(followHubVM)

      if !searchResultsDisplayed {
        followTypeToggle
          .padding(.vertical, 20)
        FollowUserListView(of: $displayedUsers)
          .environmentObject(followHubVM)
          .refreshable {
            followHubVM.isRefreshing = true
            switch followHubVM.currentFollowType {
            case .following:
              followHubVM.initFollowingUsers { result in
                if result {
                  displayedUsers = followHubVM.followingUsers
                }
              }
            case .follower:
              followHubVM.initFollowerUsers { result in
                if result {
                  displayedUsers = followHubVM.followerUsers
                }
              }
            }
          }
      } else {
        SearchedUserListView(nameToSearch: nameToSearch)
          .padding(.top, 20)
          .environmentObject(followHubVM)
      }
    }
    .background(Color.odya.background.normal)
    .onAppear {
        followHubVM.initFollowingUsers { success in
            followHubVM.initFollowerUsers { _ in }
            if success {
                displayedUsers = followHubVM.followingUsers
            }
        }
    }
    .onDisappear {
        followHubVM.currentFollowType = .following
        nameToSearch = ""
    }
    .onChange(of: followHubVM.currentFollowType) { newValue in
      displayedUsers =
        newValue == .following
        ? followHubVM.followingUsers : followHubVM.followerUsers
    }
  }

  private var followTypeToggle: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 50)
        .frame(width: 190, height: 40)
        .foregroundColor(.odya.elevation.elev5)

      RoundedRectangle(cornerRadius: 50)
        .frame(width: 91.7, height: 36)
        .foregroundColor(.odya.brand.primary)
        .offset(x: followHubVM.currentFollowType == .following ? 47.15 : -47.15)
        .animation(.easeInOut, value: followHubVM.currentFollowType)

      HStack(spacing: 2) {
        Button(action: {
          followHubVM.currentFollowType = .follower
        }) {
          Text("팔로워")
            .b1Style()
            .foregroundColor(.odya.label.inactive)
            .padding(10)
            .frame(width: 92)
        }
        Button(action: {
          followHubVM.currentFollowType = .following
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

//struct FollowListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowHubView(token: "testIdToken", userID: 1, followCount: FollowCount())
//    }
//}
