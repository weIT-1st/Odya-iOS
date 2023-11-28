//
//  AppIntroductionView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import SwiftUI

struct AppIntroductionView: View {
  @EnvironmentObject var SignUpVM: SignUpViewModel
  
  @State private var introStep: Int = 1
  
  let introMainTexts: [String] = ["저번에 너가 갔던 그 곳, \n어디야?",
                                  "지도에 쓰는 \n나의 인생장소 여행일지",
                                  "한 눈에 담아보는 \n나의 여행 동선"]
  let introSubTexts: [String] = ["친구가 방문했던 장소를 \n쉽게 찾아봐요",
                                "오댜에서 기억에 남는 장소들을 \n방문하고 공유해보세요",
                                "동선을 보여드려요"]
  let illustratorImageNames: [String] = ["talk-illust",
                                         "place-illust",
                                         "route-illust"]
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(spacing: 25) {
        stepIndicator
        introText
      }
      .padding(.horizontal, 27)
      
      illust
      
      CTAButton(isActive: .active, buttonStyle: .solid, labelText: introStep != 3 ? "다음으로" : "오댜 시작하기", labelSize: .L) {
        if introStep < 3 {
          introStep += 1
        } else {
          print("intro finish")
          SignUpVM.step += 1
        }
      }.padding(.bottom, 45)
    }
  }
  
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
  
  private var illust: some View {
    VStack {
      Image(illustratorImageNames[introStep - 1])
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: UIScreen.main.bounds.width)
    }
  }
}

struct AppIntroductionView_Previews: PreviewProvider {
  static var previews: some View {
    AppIntroductionView()
  }
}
