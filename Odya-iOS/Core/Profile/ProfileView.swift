//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

private struct BackgroundImageView: View {
  let imageUrl: String?
  let size: CGFloat = UIScreen.main.bounds.width
  
  var body: some View {
    if let url = imageUrl {
      AsyncImage(url: URL(string: url)) { image in
        ZStack {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
          Color.odya.blackopacity.baseBlackAlpha50
        }.frame(width: size, height: size)
          .blur(radius: 8)
      } placeholder: {
        defaultBG
      }
    } else {
      defaultBG
    }
  }

  private var defaultBG: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
  }
}

enum StackViewType {
  case settingView
  case followHubView
  case potoRegisterView
}

struct ProfileView: View {
  @StateObject var profileVM = ProfileViewModel()
  @StateObject var followButtonVM = FollowButtonViewModel()

  @Environment(\.dismiss) var dismiss
  @State var path: [StackViewType] = []
  
  var userId: Int = -1
  var nickname: String = ""
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
    NavigationStack(path: $path) {
      ScrollView(.vertical) {
        VStack(spacing: 24) {
          topNavigationBar
          Group {
            profileImgAndNickname
            followTotal
          }.padding(.horizontal, GridLayout.side)
        }.background(
          BackgroundImageView(imageUrl: profileVM.potdList.first?.imageUrl ?? nil)
            .offset(y: -70)
        )

        VStack(spacing: 20) {
          odyaCounter
            .padding(.horizontal, GridLayout.side)

          VStack(spacing: 36) {
            POTDTitle
              .padding(.horizontal, GridLayout.side)
            POTDListView($profileVM.potdList, isMyPOTD: isMyProfile)
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
          profileVM.initData(
            MyData.userID, myData.nickname, myData.profile.decodeToProileData().profileUrl)
        }

        Task {
          await profileVM.fetchDataAsync()
        }
      }
      .navigationDestination(for: StackViewType.self) { stackViewType in
        switch stackViewType {
        case .settingView:
          SettingView().navigationBarBackButtonHidden()
        case .followHubView:
          isMyProfile ? FollowHubView().navigationBarBackButtonHidden() : FollowHubView(userId: userId).navigationBarBackButtonHidden()
        case .potoRegisterView:
          POTDPickerView().navigationBarBackButtonHidden()
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
        IconButton("setting") {
          path.append(.settingView)
        }.padding(4)
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