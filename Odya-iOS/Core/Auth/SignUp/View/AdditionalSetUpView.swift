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
  
  /// 단계, 회원가입 인데케이터에서 사용
  @State private var step: Int = 1
  
  /// 사용자 닉네임
  @State private var nickname: String = MyData().nickname
  
  // MARK: Body
  var body: some View {
    // contents
    switch step {
    case 1, 2:
      ZStack(alignment: .bottom) {
        VStack {
          SignUpIndicatorView(step: $step)
            .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.medium))
          
          if step == 1 {
            RegisterTopicsView($step,
                               nickname: nickname)
          } else {
            RegisterFollowsView($step,
                                nickname: nickname)
          }
        }.frame(height: UIScreen.main.bounds.height - 20)
      }
    default:
      LoginView()
        .onAppear {
          self.authState = .loggedOut
        }
    }
  }  // body
}

struct SignUpView_Preview: PreviewProvider {
  static var previews: some View {
    AdditionalSetUpView()
  }
}
