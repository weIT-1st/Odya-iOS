//
//  TravelMatesView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/02.
//

import SwiftUI

// MARK: Mate Row View
private struct MateRowView: View {
  @EnvironmentObject var VM: TravelMatesViewModel
  @StateObject var followHubVM = FollowHubViewModel()
  
  let mate: TravelMate
  @Binding var isShowingTravelMateProfileView: Bool
  @State private var isShowingUnfollowingAlert: Bool = false
  @State private var followState: Bool = true

  var body: some View {
    HStack(spacing: 0) {
      Button(action: {
        if let userId = mate.userId,
           let nickname = mate.nickname,
           let profileUrl = mate.profileUrl {
          VM.selectedMateId = userId
          VM.selectedMateNickname = nickname
          VM.selectedMateProfileUrl = profileUrl
          isShowingTravelMateProfileView = true
        }
      }) {
        mateView
      }.disabled(!mate.isRegistered)
      
      Spacer()
      
      FollowButton(isFollowing: followState, buttonStyle: .solid) {
        if followState == false {  // do following
          followState = true
          followHubVM.createFollow(mate.userId ?? -1)
        } else {  // do unfollowing
          isShowingUnfollowingAlert = true
        }
      }
      .alert("팔로잉을 취소하시겠습니까?", isPresented: $isShowingUnfollowingAlert) {
        HStack {
          Button("취소") {
            followState = true
            isShowingUnfollowingAlert = false
          }
          Button("삭제") {
            followState = false
            followHubVM.deleteFollow(mate.userId ?? -1)
            isShowingUnfollowingAlert = false
          }
        }
      } message: {
        Text("팔로잉 취소는 알람이 가지 않으며, 커뮤니티 게시글 등의 구독이 취소됩니다.")
      }
    }
  }
    
  private var mateView: some View {
    HStack(spacing: 0) {
      ProfileImageView(profileUrl: mate.profileUrl ?? "", size: .S)
        .padding(.trailing, 12)
      
      Text(mate.nickname ?? "No Nickname")
        .foregroundColor(.odya.label.normal)
        .b1Style()
        .padding(.trailing, 4)
      Image("sparkle-s")
    }
  }
}

// MARK: Travel Mates View
struct TravelMatesView: View {
  @StateObject var VM = TravelMatesViewModel()
  @State private var isShowingTravelMateProfileView = false
  @Environment(\.dismiss) var dismiss
  
  let mates: [TravelMate]
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text("함께 간 친구")
          .h4Style()
          .foregroundColor(.odya.label.normal)
          .padding(.vertical, 26)
        Spacer()
      }
      
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 16) {
          ForEach(mates) { mate in
            MateRowView(mate: mate, isShowingTravelMateProfileView: $isShowingTravelMateProfileView)
              .environmentObject(VM)
          }
        }
      }
    }
    .padding(.vertical, 12)
    .padding(.horizontal, GridLayout.side)
    .fullScreenCover(isPresented: $isShowingTravelMateProfileView) {
      ProfileView(userId: VM.selectedMateId, nickname: VM.selectedMateNickname, profileUrl: VM.selectedMateProfileUrl)
    }
  }
}

// MARK: Preview
struct TravelMatesView_Previews: PreviewProvider {

  static var previews: some View {
    TravelMatesView(
      mates: [
        TravelMate(userId: 1, nickname: "홍길동aa1", profileUrl: "", isRegistered: true),
        TravelMate(userId: 2, nickname: "홍길동aa2", profileUrl: "", isRegistered: true),
        TravelMate(userId: 3, nickname: "홍길동aa3", profileUrl: "", isRegistered: true),
        TravelMate(userId: 4, nickname: "홍길동aa4", profileUrl: "", isRegistered: true),
        TravelMate(userId: 5, nickname: "홍길동aa5", profileUrl: "", isRegistered: true),
      ]
    )

  }
}
