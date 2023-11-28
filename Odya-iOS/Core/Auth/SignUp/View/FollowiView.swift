//
//  FollowiView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/28.
//

import SwiftUI

struct RegisterFollowsView: View {
  @EnvironmentObject var signUpVM: SignUpViewModel
  
  var nickname: String { signUpVM.nickname }
  
  var body: some View {
    VStack {
      VStack(alignment: .leading) {
        titleText
          .frame(height: 130) // 뒷페이지와 높이 맞추기용
          .padding(.top, 120) // 뒷페이지와 높이 맞추기용
          .padding(.bottom, 30) // 뒷페이지와 높이 맞추기용
        
        // 알 수도 있는 친구
        HStack {
          ScrollView(.horizontal, showsIndicators: false) {
            // TODO
            // 연락처 기반 친구 추천 리스트
          }
        }
        
        
      }.padding(.horizontal, GridLayout.side)
      
      Spacer()
      
      
      // next button
      CTAButton( isActive: .active, buttonStyle: .solid, labelText: "등록 완료", labelSize: .L) {
        signUpVM.step += 1
      }
      .padding(.bottom, 45)
    }
    .onAppear {

    }
  }
  
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


struct RegisterFollowsView_Previews: PreviewProvider {
  static var previews: some View {
    SignUpView()
  }
}
