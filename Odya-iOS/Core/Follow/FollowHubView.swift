//
//  FollowHubView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/10.
//

import SwiftUI

struct FollowUserListView: View {
    var followType: FollowType
    @Binding var displayedUsers: [FollowUser]
    var maxCountBeforeSuggestion: Int = 8
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(displayedUsers.enumerated()), id: \.element.id) { index, user in
                    switch followType {
                    case .following:
                        FollowingUserRowView(userData: user.userData, followState: user.followState)
                    case .follower:
                        FollowerUserRowView(userData: user.userData)
                    }
                    if index == maxCountBeforeSuggestion - 1
                        || (index < maxCountBeforeSuggestion && index == displayedUsers.count - 1) {
                        UserSuggestionView()
                    }
                }
            }
        }
    }
}

struct FollowSearchBar: View {
    var promptText: String
    @ObservedObject var followHubVM: FollowHubViewModel
    
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
//        .onChange(of: nameToSearch) { newValue in
//            if newValue.count = 0 {
//
//            } else {
//
//            }
//        }

    }
}

struct FollowHubView: View {
    @State private var followType: FollowType = .following
    @ObservedObject var followHubVM: FollowHubViewModel
    
    init(userID: String) {
        self.followHubVM = FollowHubViewModel(userID: userID)
    }
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "친구 관리")
            FollowSearchBar(promptText: "친구를 찾아보세요!", followHubVM: followHubVM)
            followTypeToggle
                .padding(.vertical, 20)
            FollowUserListView(followType: followType, displayedUsers: $followHubVM.displayedUsers)
        }
        .onChange(of: followType) { newValue in
            followHubVM.setDisplayedUsers(followType: newValue)
        }
        .onAppear {
            followHubVM.setDisplayedUsers(followType: followType)
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
        FollowHubView(userID: "testIdToken")
    }
}
