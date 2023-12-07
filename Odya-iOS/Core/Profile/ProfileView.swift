//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI
import Photos

struct ProfileView: View {
  @ObservedObject var profileVM: ProfileViewModel
  @StateObject var followHubVM = FollowHubViewModel()
  
  @Environment(\.dismiss) var dismiss
  
  var isMyProfile: Bool {
    profileVM.userID == MyData.userID
  }
  
  @State private var isShowingUpdateProfileImageAlert: Bool = false
  @State private var isShowingImagePickerSheet: Bool = false
  @State private var isShowingUnfollowingAlert: Bool = false
  
  @State private var imageAccessStatus: PHAuthorizationStatus = .authorized
  @State private var selectedImage: [ImageData] = []
  @State private var followState: Bool = true
  
  init() {
    profileVM = ProfileViewModel()
  }
  
  init(userId: Int, nickname: String, profileUrl: String) {
    profileVM = ProfileViewModel(userId: userId, nickname: nickname, profileUrl: profileUrl)
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
        Task {
          if !isMyProfile {
            followHubVM.isMyFollowingUser(profileVM.userID) { result in
              self.followState = result
            }
          }
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
  
  // MARK: Profile
 
extension ProfileView {
  private var profileImgAndNickname: some View {
    VStack(spacing: 24) {
      // profile image
      ZStack {
        ProfileImageView(profileUrl: profileVM.profileUrl, size: .XL)
        
        if isMyProfile {
          profileImageEditButton
        }
      }
      
      // nickname
      HStack(spacing: 12) {
        Text(profileVM.nickname)
          .h3Style()
        
        // if not my profile, follow button
        if !isMyProfile {
          followButton
        }
      }
      
    } // VStack
  }
  
  /// 배경
  private var bgImage: some View {
    Rectangle()
      .foregroundColor(.clear)
      .background(.black.opacity(0.5))
      .background(
        Color.odya.brand.primary
      )
      .blur(radius: 8)
  }
  
  /// 프로필이미지 변경 버튼
  private var profileImageEditButton: some View {
    IconButton("camera") {
      isShowingUpdateProfileImageAlert = true
    }
    .disabled(profileVM.isUpdatingProfileImg)
    .background(Color.odya.label.inactive)
    .cornerRadius(50)
    .offset(x: ComponentSizeType.XL.ProfileImageSize / 2 - 15, y: ComponentSizeType.XL.ProfileImageSize / 2 - 15)
    // 프로필 이미지 변경 방식 선택 alert
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
    // 포토피커 띄우기
    .sheet(isPresented: $isShowingImagePickerSheet) {
      PhotoPickerView(imageList: $selectedImage, maxImageCount: 1, accessStatus: imageAccessStatus)
    }
    // 포토피커로 고른 사진으로 프로필 이미지 변경
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
  }
  
  /// 타인의 프로필 뷰인 경우, 팔로잉 버튼
  /// 팔로우/언팔로우 시 follow Count 값을 같이 바꿔줌
  private var followButton: some View {
    FollowButton(isFollowing: followState, buttonStyle: .solid) {
      if followState == false {  // do following
        followState = true
        // 팔로우 -> 팔로워 수 1 증가
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
          // 언팔로우 -> 팔로워 수 1 감소
          profileVM.statistics.followersCount -= 1
          followHubVM.deleteFollow(profileVM.userID)
          isShowingUnfollowingAlert = false
        }
      }
    } message: {
      Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
    }
  }
}
  
// MARK: Follow Count
extension ProfileView {
  private var followTotal: some View {
    NavigationLink(
      destination: isMyProfile ? FollowHubView().navigationBarHidden(true) : FollowHubView(userId: profileVM.userID).navigationBarHidden(true)
    ) {
      HStack(spacing: 20) {
        Spacer()
        
        getCountStackView(of: "총오댜", count: profileVM.statistics.odyaCount)
        
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        
        getCountStackView(of: "팔로잉", count: profileVM.statistics.followingsCount)
        
        Divider().frame(width: 1, height: 30).background(Color.odya.label.alternative)
        
        getCountStackView(of: "팔로우", count: profileVM.statistics.followersCount)
        
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
  
  private func getCountStackView(of title: String, count: Int) -> some View {
    VStack {
      Text(title)
        .b1Style().foregroundColor(.odya.label.alternative)
      Text("\(count)")
        .h4Style().foregroundColor(.odya.label.normal)
    }
  }
}

// MARK: Odya Counter
extension ProfileView {
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
  }
}

// MARK: POTD
extension ProfileView {
  private var POTDTitle: some View {
    HStack {
      Text(isMyProfile ? "내 인생 샷" : "인생 샷")
        .h4Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
      NavigationLink(destination: {
        POTDPickerView()
          .navigationBarBackButtonHidden()
      }) {
        Image("plus")
          .renderingMode(.template)
          .foregroundColor(isMyProfile ? .odya.label.normal : .clear)
          .padding(6)
      }.disabled(!isMyProfile)
    }
  }
  
  private var POTDList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(profileVM.potdList, id: \.id) { image in
          POTDCardView(imageUrl: image.imageUrl, place: image.placeName)
        }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
