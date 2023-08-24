//
//  SignUpView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct SignupHeaderBar: View {
  @Binding var step: Int

  var body: some View {
    HStack {
      Button(
        action: {
          print("뒤로가기")
          step -= 1
        },
        label: {
          Text("뒤로가기")
            .detail2Style()
            .foregroundColor(step > 1 ? Color.odya.brand.primary : Color.odya.background.normal)
        }
      ).disabled(step <= 1)

      Spacer()
      SignupStepIndicator
      Spacer()

      Button(
        action: {
          print("건너뛰기")
          step += 1
        },
        label: {
          Text("건너뛰기")
            .detail2Style()
            .foregroundColor(step > 2 ? Color.odya.brand.primary : Color.odya.background.normal)
        }
      ).disabled(step <= 2)
    }
    .frame(height: 56)
  }

  var SignupStepIndicator: some View {
    HStack(spacing: 8) {
      ForEach(1...4, id: \.self) { index in
        Circle()
          .frame(width: 8, height: 8)
          .foregroundColor(step >= index ? .odya.brand.primary : .odya.system.inactive)
      }
    }

  }
}

struct SignUpView: View {

  @AppStorage("WeITAuthToken") var idToken: String?

  @EnvironmentObject var appleAuthVM: AppleAuthViewModel
  @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel
  @StateObject private var authApi = AuthViewModel()

  @State var step: Int = 1
  let lastStep = 2

  @State var userInfo: UserInfo

  var body: some View {
    ZStack {
      Color.odya.background.normal.ignoresSafeArea()

      // contents
      switch step {
      case 1:
        RegisterNicknameView(
          step: $step,
          nickname: $userInfo.nickname)
      case 2:
        RegisterDefaultInfoView(
          step: $step,
          nickname: userInfo.nickname,
          birthday: $userInfo.birthday,
          gender: $userInfo.gender)
      case 3:
        ProgressView()
          .onAppear {
            let birthdayArray = getBirthdayArray(userInfo.birthday)
            let genderString = userInfo.gender.toServerForm()

            // TODO: 회원가입 api 호출
            if appleAuthVM.isUnauthorized {
              print("do apple register")
              authApi.appleRegister(
                idToken: userInfo.idToken, email: userInfo.email, phoneNumber: userInfo.phoneNumber,
                nickname: userInfo.nickname, gender: genderString, birthday: birthdayArray
              ) { result, errorMessage in
                guard result else {
                  print("Error in SignUpView appleRegister() - \(String(describing: errorMessage))")
                  // TODO: 서버로그인 실패 에러처리
                  return
                }
                idToken = userInfo.idToken
              }
            } else {
              print("do kakao register")
              authApi.kakaoRegister(
                username: userInfo.username, email: userInfo.email,
                phoneNumber: userInfo.phoneNumber, nickname: userInfo.nickname,
                gender: genderString, birthday: birthdayArray
              ) { result, errorMessage in
                guard result else {
                  print("Error in SignUpView kakaoRegister() - \(String(describing: errorMessage))")
                  // TODO: 서버로그인 실패 에러처리
                  return
                }
                if let kakaoToken = kakaoAuthVM.kakaoAccessToken {
                  kakaoAuthVM.doServerLogin(token: kakaoToken)
                }
                //                                kakaoAuthVM.isUnauthorized = false
              }
            }
          }
      default:
        LoginView()
      }
    }  // background color ZStack
  }  // body

  private func getBirthdayArray(_ birthday: Date) -> [Int] {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: birthday)
    if let year = components.year,
      let month = components.month,
      let day = components.day
    {
      return [year, month, day]
    }
    return []
  }
}

struct SignUpView_Preview: PreviewProvider {
  static var previews: some View {
    SignUpView(userInfo: UserInfo(nickname: "길동아밥먹자"))
  }
}
