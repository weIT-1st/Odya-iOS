//
//  AppIntroductionView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import SwiftUI

/// 회원가입 시 앱 소개 내용이 포함된 뷰
/// 총 3개의 뷰가 있으며 뷰 이동 시 introStep이 1씩 커짐
/// 3개의 설명 뷰를 모두 확인하면 signUpStep이 1 커지고 회원가입을 시작함
struct AppIntroductionView: View {
  /// 회원가입 단계
  @Binding var signUpStep: SignUpStep
  
  /// 앱 설명 단계
  @State private var introStep: Int = 1
  
  /// 앱 설명 각 단계별 메인 내용
  let introMainTexts: [String] = ["저번에 너가 갔던 그 곳, \n어디야?",
                                  "지도에 쓰는 \n나의 인생장소 여행일지",
                                  "한 눈에 담아보는 \n나의 여행 동선"]
  /// 앱 설명 각 단계별 서브 내용
  let introSubTexts: [String] = ["친구가 방문했던 장소를 \n쉽게 찾아봐요",
                                "오댜에서 기억에 남는 장소들을 \n방문하고 공유해보세요",
                                "동선을 보여드려요"]
  /// 앱 설명 각 단계별 일러스트
  let illustratorImageNames: [String] = ["talk-illust",
                                         "place-illust",
                                         "route-illust"]
  
  init(_ signUpStep: Binding<SignUpStep>) {
    self._signUpStep = signUpStep
  }
  
  // MARK: Body
  var body: some View {
    VStack {
      Spacer()
      
      VStack(spacing: 25) {
        // 앱 셜명 단계 인디케이터
        stepIndicator
        
        // 앱 설명 내용
        introText
      }
      .padding(.horizontal, 27)
      
      // 앱 설명 일러스트
      illust
      
      // 다음 앱설명 단계 넘어가는 버튼
      CTAButton(isActive: .active,
                buttonStyle: .solid,
                labelText: introStep != 3 ? "다음으로" : "오댜 시작하기",
                labelSize: .L) {
        // 마지막 앱설명 단계일 경우 회원가입 단계가 다음으로 넘어감
        if introStep == 3 {
          signUpStep.nextStep()
        } else {
          introStep += 1
        }
      }.padding(.bottom, 45)
    }
  }
  
  // MARK: Step Indicator
  private var stepIndicator: some View {
    HStack(spacing: 8) {
      ForEach(1...3, id: \.self) { index in
        Circle()
          .frame(width: 12, height: 12)
          .foregroundColor(introStep == index ? .odya.label.normal : .odya.label.inactive)
      }
      Spacer()
    }.padding(.horizontal, 3)
  }
  
  // MARK: Intro Text
  private var introText: some View {
    VStack(spacing: 10) {
      HStack {
        Text(introMainTexts[introStep - 1])
          .h3Style()
        Spacer()
      }
      
      HStack {
        Text(introSubTexts[introStep - 1])
          .detail2Style()
        Spacer()
      }.frame(height: 35)
      
    }.foregroundColor(.odya.label.normal)
  }
  
  // MARK: Into illust
  private var illust: some View {
    VStack {
      Image(illustratorImageNames[introStep - 1])
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: UIScreen.main.bounds.width)
    }
  }
}

//struct AppIntroductionView_Previews: PreviewProvider {
//  static var previews: some View {
//    AppIntroductionView()
//  }
//}
