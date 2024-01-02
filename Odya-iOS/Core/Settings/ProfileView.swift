//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI
import Photos

enum StackViewType {
  case settingView
  case followHubView
}

struct ProfileView: View {
  @StateObject var profileVM = ProfileViewModel()
  @StateObject var followHubVM = FollowHubViewModel()
  
  @State private var path: [StackViewType] = []
  
  @Environment(\.dismiss) var dismiss
  
  var userId: Int = -1
  var nickname: String =  ""
  var profileUrl: String = ""
  
  var isMyProfile: Bool {
    profileVM.userID == MyData.userID
  }
  
  @State private var isShowingUpdateProfileImageAlert: Bool = false
  @State private var isShowingImagePickerSheet: Bool = false
  @State private var isShowingUnfollowingAlert: Bool = false
  
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
  @State private var selectedImage: [ImageData] = []
  @State private var followState: Bool? = nil
  
  init() {}
  
  init(userId: Int, nickname: String, profileUrl: String, isFollowing: Bool? = nil) {
    self.userId = userId
    self.nickname = nickname
    self.profileUrl = profileUrl
    self.followState = isFollowing
  }

  // MARK: Body
  
  var body: some View {
    NavigationStack(path: $path) {
      VStack(spacing: 20) {
        VStack(spacing: 24) {
          topNavigationBar
          profileImgAndNickname
            .padding(.horizontal, GridLayout.side)
          followTotal
            .padding(.horizontal, GridLayout.side)
        }.background(
          bgImage.offset(y: -70)
        )
        
        odyaCounter
        
        Spacer()
        
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
          if !isMyProfile && followState == nil {
            followHubVM.isMyFollowingUser(profileVM.userID) { result in
              self.followState = result
            }
          }
          await profileVM.fetchDataAsync()
        }
      }
      .navigationDestination(for: StackViewType.self) { stackViewType in
        switch stackViewType {
        case .settingView:
          SettingView().navigationBarBackButtonHidden()
        case .followHubView:
          isMyProfile ? FollowHubView().navigationBarBackButtonHidden() : FollowHubView(userId: userId).navigationBarBackButtonHidden()
        }
      }
    }
  }
  
  // MARK: Navigation Bar
  
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
  
  // MARK: Profile
  
  private var profileImgAndNickname: some View {
    VStack(spacing: 24) {
      // profile image
      ZStack {
        ProfileImageView(profileUrl: profileVM.profileUrl, size: .XL)
        
        if isMyProfile {
          IconButton("camera") {
            isShowingUpdateProfileImageAlert = true
          }
          .disabled(profileVM.isUpdatingProfileImg)
          .background(Color.odya.label.inactive)
          .cornerRadius(50)
          .offset(x: ComponentSizeType.XL.ProfileImageSize / 2 - 15, y: ComponentSizeType.XL.ProfileImageSize / 2 - 15)
        }
      } // profile iamge ZStack
      .confirmationDialog("", isPresented: $isShowingUpdateProfileImageAlert) {
        Button("앨범에서 사진 선택") {
          isShowingUpdateProfileImageAlert = false
          isShowingImagePickerSheet = true
        }
        Button("기본 이미지로 변경") {
          isShowingUpdateProfileImageAlert = false
          // api with Null
          Task {
            await profileVM.updateProfileImage(newProfileImg: [])
          }
        }
        Button("취소", role: .cancel) { print("취소 클릭") }
      }
      .sheet(isPresented: $isShowingImagePickerSheet) {
        PhotoPickerView(imageList: $selectedImage, maxImageCount: 1, accessStatus: imageAccessStatus)
      }
      .onChange(of: selectedImage) { newValue in
        if newValue.count == 1 {
          print("get new profile image")
          // api with UIImage
          Task {
            await profileVM.updateProfileImage(newProfileImg: newValue)
          }
          selectedImage = []
        }
      }
      
      // nickname
      HStack(spacing: 12) {
        Text(profileVM.nickname)
          .foregroundColor(.odya.label.normal)
          .h3Style()
        
        // if not my profile, follow button
        if !isMyProfile {
          FollowButton(isFollowing: followState ?? false, buttonStyle: .solid) {
            if followState == false {  // do following
              followState = true
              profileVM.statistics.followersCount += 1
              followHubVM.createFollow(profileVM.userID)
            } else {  // do unfollowing
              isShowingUnfollowingAlert = true
            }
          }
          .animation(.default, value: followState)
          .alert("팔로잉을 취소하시겠습니까?", isPresented: $isShowingUnfollowingAlert) {
            HStack {
              Button("취소") {
                isShowingUnfollowingAlert = false
              }
              Button("삭제") {
                followState = false
                profileVM.statistics.followersCount -= 1
                followHubVM.deleteFollow(profileVM.userID)
                isShowingUnfollowingAlert = false
              }
            }
          } message: {
            Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
          }
        }
      } // nickname HStack
    } // VStack
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
  
  // MARK: Follow Count
  
  private var followTotal: some View {
    Button(action: {
      path.append(.followHubView)
    }) {
      HStack(spacing: 20) {
        Spacer()
        VStack {
          Text("총오댜")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.odyaCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        VStack {
          Text("팔로잉")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.followingsCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        VStack {
          Text("팔로우")
            .b1Style().foregroundColor(.odya.label.alternative)
          Text("\(profileVM.statistics.followersCount)")
            .h4Style().foregroundColor(.odya.label.normal)
        }
        Spacer()
      }
      .frame(height: 80)
      .background(Color.odya.whiteopacity.baseWhiteAlpha20)
      .cornerRadius(Radius.large)
      .overlay (
        RoundedRectangle(cornerRadius: Radius.large)
          .inset(by: 0.5)
          .stroke(Color.odya.line.alternative, lineWidth: 1)
      )
    }
  }
  
  // MARK: Odya Counter
  private var odyaCounter: some View {
    VStack(spacing: 28) {
      Image("odya")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 70)
        .frame(maxWidth: .infinity)
      
      VStack {
        HStack(spacing: 0) {
          Text("\(profileVM.nickname)님은 ")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Text("\(profileVM.statistics.travelPlaceCount)곳을 ")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
          Text("여행하고,")
            .b1Style()
            .foregroundColor(.odya.label.normal)
        }
        HStack(spacing: 0) {
          Text("총 ")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          Text("\(profileVM.statistics.travelJournalCount)개의 ")
            .b1Style()
            .foregroundColor(.odya.brand.primary)
          Text("여행일지를 작성했어요!")
            .b1Style()
            .foregroundColor(.odya.label.normal)
        }.padding(.bottom)
      }.multilineTextAlignment(.center)
    }
    .padding(.horizontal, 10)
    .padding(.vertical, 24)
    .background(Color.odya.elevation.elev3)
    .cornerRadius(Radius.large)
    .padding(.horizontal, GridLayout.side)
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
