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
  @StateObject var followHubVM = FollowHubViewModel()
  
  let userId: Int
  var isMyFollowHub: Bool {
    userId == MyData.userID
  }
  
  /// 화면에 표시되는 리스트 - 팔로워리스트 / 팔로잉리스트 / 검색 결과 리스트
  var displayedUsers: [FollowUserData] {
    switch followHubVM.currentFollowType {
    case .following:
      return followHubVM.followingUsers
    case .follower:
      return followHubVM.followerUsers
    }
  }
  
  /// 검색하려는 닉네임
  @State var nameToSearch: String = ""
  
  /// 검색 결과 표시 여부
  @State var searchResultsDisplayed: Bool = false

  init(userId: Int = MyData.userID) {
    self.userId = userId
  }
  
  // MARK: Body
  var body: some View {
    VStack {
      CustomNavigationBar(title: "친구 관리")
      
      FollowSearchBar(
        promptText: "친구를 찾아보세요!",
        nameToSearch: $nameToSearch,
        searchResultsDisplayed: $searchResultsDisplayed
      )

      // 디폴트, 모든 팔로잉/팔로워 리스트 보기
      if !searchResultsDisplayed {
        // 팔로워 / 팔로잉 선택 토글
        followTypeToggle
          .padding(.vertical, 20)
        
        // 리스트
        FollowUserListView
          .refreshable {
            followHubVM.refreshFollowingFollower(userId: userId)
          }
      }
      
      // 닉네임을 검색한 경우, 검색 결과 보기
      else {
        SearchedUserListView(userId: userId, nameToSearch: nameToSearch)
          .padding(.top, 20)
          .environmentObject(followHubVM)
      }
      
    } // main VStack
    .background(Color.odya.background.normal)
    .onAppear {
      followHubVM.initFollowingFollower(userId: userId)
    }
    .onDisappear {
      followHubVM.currentFollowType = .following
      nameToSearch = ""
    }
  }

  // MARK: Follow Type Toggle
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
