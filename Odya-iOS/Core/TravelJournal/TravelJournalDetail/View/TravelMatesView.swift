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
      
      FollowButtonWithAlertAndApi(userId: mate.userId ?? -1, buttonStyle: .solid)
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
