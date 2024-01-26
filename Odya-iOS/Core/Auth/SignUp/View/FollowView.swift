//
//  FollowView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/28.
//

import SwiftUI

private struct UserSuggestionByContactsView: View {
  @StateObject var VM = UserSuggestionByContactsViewModel()
  
  var body: some View {
    Group {
      if VM.suggestedUsers.isEmpty {
        HStack {
          Spacer()
          if VM.isLoading {
            ProgressView()
          } else {
            Text("추천 가능한 친구가 없어요!!")
              .detail1Style()
              .foregroundColor(.odya.label.assistive)
          }
          Spacer()
        }.padding(.horizontal, GridLayout.side)
      }
      
      else {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 32) {
            ForEach(VM.suggestedUsers) { suggestedUser in
              SuggestedUserView(user: suggestedUser)
            }
          }
        }.padding(.leading, GridLayout.side)
      }
    }
    .frame(height: 137)
    .padding(.vertical, 28)
  }

}

/// 팔로우 가능한 친구를 추천해주는 뷰
struct RegisterFollowsView: View {
  
  /// 회원가입 단계
  @Binding var isModalOn: Bool
  
  /// 사용자 닉네임
  let nickname: String
  
  init(_ isModalOn: Binding<Bool>, nickname: String) {
    self._isModalOn = isModalOn
    self.nickname = nickname
  }
  
  // MARK: Body
  
  var body: some View {
    VStack {
      
      Spacer()
      
      VStack(alignment: .leading, spacing: 0) {
        // title
        titleText
          .frame(height: 160) // 뒷페이지와 title height 맞추기용
        
        // 알 수도 있는 친구
        UserSuggestionByContactsView()
        
      }
      .frame(minHeight: 300, maxHeight: 380)
      .padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      // next button
      CTAButton( isActive: .active, buttonStyle: .solid, labelText: "오댜 시작하기", labelSize: .L) {
        self.isModalOn = false
        
      }
      .padding(.bottom, 45)
    }
  }
  
  // MARK: Title
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 0) {
        Text("활동중인 친구를")
          .foregroundColor(.odya.label.normal)
        Text("오댜에서 만나요!")
          .foregroundColor(.odya.brand.primary)
      }
      .frame(height: 49)
      .h3Style()
      
      Text("연락처에 있는 친구를 추천해드려요")
        .b2Style()
        .foregroundColor(.odya.label.normal)
        .frame(height: 12)
      
      Spacer()
    }
  }
}


//struct RegisterFollowsView_Previews: PreviewProvider {
//  static var previews: some View {
//    SignUpView()
//  }
//}
