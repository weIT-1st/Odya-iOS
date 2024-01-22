//
//  SignUpIndicatorView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2024/01/22.
//

import SwiftUI

/// 사용자 정보를 입력받는 2단계에 대한 인디케이터
struct SignUpIndicatorView: View {
  @Binding var step: Int
  
  var body: some View {
    VStack {
      backButton
      stepIndicator
    }
  }
  
  private var backButton: some View {
    // 첫 단계 제외 뒤로가기 버튼 표시
    HStack {
      Button( action: { step -= 1 }) {
        Text("뒤로가기")
          .detail2Style()
          .foregroundColor(step == 1 ? Color.odya.background.normal : Color.odya.brand.primary)
          .frame(height: 56)
      }.disabled(step == 1)
      Spacer()
    }.padding(.horizontal, GridLayout.side)
  }
  
  private var stepIndicator: some View {
    ZStack {
      Rectangle()
        .foregroundColor(.odya.system.inactive)
        .frame(width: UIScreen.main.bounds.width, height: 6)
      
      let activeBarLength: CGFloat = (UIScreen.main.bounds.width / 2) * CGFloat(step)
      HStack(spacing: 0) {
        Rectangle()
          .foregroundColor(.odya.brand.primary)
          .frame(width: activeBarLength, height: 6)
        Spacer()
      }.animation(.easeInOut, value: activeBarLength)
    }
  }
}
