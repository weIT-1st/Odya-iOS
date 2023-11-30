//
//  FollowiView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/28.
//

import SwiftUI

/// 팔로우 가능한 친구를 추천해주는 뷰
struct RegisterFollowsView: View {
  
  /// 회원가입 단계
  @Binding var signUpStep: Int
  
  /// 회원가입한 사용자 정보
  @Binding var userInfo: SignUpInfo
  
  /// 사용자 닉네임
  var nickname: String { userInfo.nickname }
  
  init(_ step: Binding<Int>, userInfo: Binding<SignUpInfo>) {
    self._signUpStep = step
    self._userInfo = userInfo
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
        HStack {
          ScrollView(.horizontal, showsIndicators: false) {
            // TODO: 연락처 기반 친구 추천 리스트
          }
        }
      }
      .frame(minHeight: 300, maxHeight: 380)
      .padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      // next button
      CTAButton( isActive: .active, buttonStyle: .solid, labelText: "등록 완료", labelSize: .L) {
        signUpStep += 1
      }
      .padding(.bottom, 45)
    }
  }
  
  // MARK: Title
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 10) {
      VStack(alignment: .leading, spacing: 0) {
          Text("활동중인 친구를")
          .foregroundColor(.odya.label.normal)
          Text("팔로우 해주세요!")
          .foregroundColor(.odya.brand.primary)
      }.h3Style()
      
      Text("연락처 기반 친구 추천")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
      
      Spacer()
    }
  }
}


//struct RegisterFollowsView_Previews: PreviewProvider {
//  static var previews: some View {
//    SignUpView()
//  }
//}
