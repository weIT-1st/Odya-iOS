//
//  AdditionalSetUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/12/05.
//

import SwiftUI


// MARK: Additional SetUp View

/// 회원가입 완료 후 관심토픽, 팔로잉 친구를 설정하는 부분
struct AdditionalSetUpView: View {
  
  /// 계정 상태, 모든 정보를 설정 완료 후 로그인 상태로 변경
  @AppStorage("WeITAuthState") var authState: AuthState = .loggedOut
  
  @Binding var isModalOn: Bool
  
  /// 단계, 회원가입 인데케이터에서 사용
  @State private var step: Int = 1
  
  /// 사용자 닉네임
  @State private var nickname: String = MyData().nickname
  
  init(_ isModalOn: Binding<Bool>) {
    self._isModalOn = isModalOn
  }
  
  // MARK: Body
  var body: some View {
    // contents
    VStack {
      HStack {}
        .frame(height: 20)
      
      VStack {
        SignUpIndicatorView(step: $step)
          .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.medium))
        
        if step == 1 {
          RegisterTopicsView($step,
                             nickname: nickname)
        } else {
          RegisterFollowsView($isModalOn,
                              nickname: nickname)
        }
      }.background(Color.odya.background.normal)
      
    }.clearModalBackground()
      .onDisappear {
        authState = .loggedIn
      }
  }  // body
}

//struct SignUpView_Preview: PreviewProvider {
//  static var previews: some View {
//    AdditionalSetUpView()
//  }
//}
