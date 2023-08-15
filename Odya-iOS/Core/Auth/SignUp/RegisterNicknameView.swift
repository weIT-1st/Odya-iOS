//
//  RegisterNickname.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/29.
//

import SwiftUI

struct RegisterNicknameView: View {
  @Binding var step: Int
  @Binding var nickname: String

  var body: some View {
    ZStack {
      // content
      VStack {
        HStack {
          Text("오댜에서 활동할 \n이름을 알려주세요!")
            .h3Style()
            .foregroundColor(.odya.label.normal)
          Spacer()
        }

        HStack(spacing: 0) {
          TextField("홍길동", text: $nickname)
            .foregroundColor(.odya.label.inactive)
            .b1Style()
            .frame(maxWidth: .infinity)
          IconButton("smallGreyButton-x") {
            nickname = ""
          }
        }
        .frame(maxHeight: 24)
        .modifier(CustomFieldStyle())
      }

      // next button
      VStack {
        Spacer()
        CTAButton(
          isActive: .active, buttonStyle: .solid,
          labelText: "다음으로", labelSize: .L,
          action: {
            // TODO: 닉네임 valid한지 체크! 지금은 널스트링만 확인
            if self.nickname.count != 0 {
              self.step += 1
            } else {
              print("invalid nickname")
            }
          }
        ).padding(.bottom, 45)
      }
    }.padding(.horizontal, GridLayout.side)
  }  // body
}

struct RegisterNicknameView_Previews: PreviewProvider {
  static var previews: some View {
    RegisterNicknameView(step: .constant(1), nickname: .constant("홍길동"))
  }
}
