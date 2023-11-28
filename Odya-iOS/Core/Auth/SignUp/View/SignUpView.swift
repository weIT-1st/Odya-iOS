//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct SignUpView: View {

  @AppStorage("WeITAuthToken") var idToken: String?

  @EnvironmentObject var appleAuthVM: AppleAuthViewModel
  @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel
  @StateObject private var authApi = AuthViewModel()
  @StateObject private var SignUpVM = SignUpViewModel()

  var step : Int { SignUpVM.step }
  let lastStep = 2

//  @State var userInfo: UserInfo

  var body: some View {
    ZStack {
      Color.odya.background.normal.ignoresSafeArea()

      // contents
      switch step {
      case -1:
        AppIntroductionView()
          .environmentObject(SignUpVM)
      case 0:
        TermsView(termsList: $SignUpVM.termsIdList)
          .environmentObject(SignUpVM)
      case 1...4:
        RegisterUserInfoView()
          .environmentObject(SignUpVM)
      case 5:
        MainLoadingView()

//        ProgressView()
//          .onAppear {
//            let birthdayArray = getBirthdayArray(userInfo.birthday)
//            let genderString = userInfo.gender.toServerForm()
//
//            // TODO: 회원가입 api 호출
//            if appleAuthVM.isUnauthorized {
//              print("do apple register")
//              authApi.appleRegister(
//                idToken: userInfo.idToken, email: userInfo.email, phoneNumber: userInfo.phoneNumber,
//                nickname: userInfo.nickname, gender: genderString, birthday: birthdayArray, termsIdList: userInfo.termsIdList
//              ) { result, errorMessage in
//                guard result else {
//                  print("Error in SignUpView appleRegister() - \(String(describing: errorMessage))")
//                  // TODO: 서버로그인 실패 에러처리
//                  return
//                }
//                idToken = userInfo.idToken
//              }
//            } else {
//              print("do kakao register")
//              authApi.kakaoRegister(
//                username: userInfo.username, email: userInfo.email,
//                phoneNumber: userInfo.phoneNumber, nickname: userInfo.nickname,
//                gender: genderString, birthday: birthdayArray, termsIdList: userInfo.termsIdList
//              ) { result, errorMessage in
//                guard result else {
//                  print("Error in SignUpView kakaoRegister() - \(String(describing: errorMessage))")
//                  // TODO: 서버로그인 실패 에러처리
//                  return
//                }
//                if let kakaoToken = kakaoAuthVM.kakaoAccessToken {
//                  kakaoAuthVM.doServerLogin(token: kakaoToken)
//                }
//                //                                kakaoAuthVM.isUnauthorized = false
//              }
//            }
//          }
      default:
        LoginView()
      }
    }  // background color ZStack
  }  // body
}

struct SignUpView_Preview: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
