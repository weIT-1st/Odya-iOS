//
//  RegisterNickname.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/29.
//

import SwiftUI

struct SignupStepIndicator: View {
    @State var step: Int

    var body: some View {
        HStack(spacing: 8) {
            Circle().frame(width: 8, height: 8)
                .foregroundColor(step >= 1 ? .odya.brand.primary : .odya.system.inactive)
            Circle().frame(width: 8, height: 8)
                .foregroundColor(step >= 2 ? .odya.brand.primary : .odya.system.inactive)
            Circle().frame(width: 8, height: 8)
                .foregroundColor(step >= 3 ? .odya.brand.primary : .odya.system.inactive)
            Circle().frame(width: 8, height: 8)
                .foregroundColor(step >= 4 ? .odya.brand.primary : .odya.system.inactive)
        }
    }
}

struct SignupHeaderBar: View {
    @State var step: Int
    
    var body: some View {
        HStack {
            Button(action: {
                print("뒤로가기")
            }, label: {
                Text("뒤로가기")
                    .detail2Style()
                    .foregroundColor(step > 1 ? Color.odya.brand.primary : Color.odya.background.normal)
            }).disabled(step <= 1)
            
            Spacer()
            
            SignupStepIndicator(step: step)
            
            Spacer()
            
            Button(action: {
                print("건너뛰기")
            }, label: {
                Text("건너뛰기")
                    .detail2Style()
                    .foregroundColor(Color.odya.brand.primary)
            })
        }
        .frame(height: 56)
    }
}

struct RegisterNicknameView: View {
    var step = 2
    @State var nickname: String = ""
    
    var body: some View {
        ZStack {
            Color.odya.background.normal.ignoresSafeArea()
            
            ZStack { // main
                VStack {
                    SignupHeaderBar(step: 2)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("오댜에서 활동할 \n이름을 알려주세요!")
                        .h3Style()
                        .foregroundColor(.odya.label.normal)
                    
                    HStack(spacing: 0) {
                        TextField("홍길동", text: $nickname)
                            .foregroundColor(.odya.label.inactive)
                            .b1Style()
                            .frame(maxWidth: .infinity)
                        Button {
                            nickname = ""
                        } label: {
                            Image("smallGreyButton-x")
                        }
                        .padding(.horizontal, 12)
                    }
                    .frame(maxHeight: 24)
                    .padding(12)
                    .background(Color.odya.elevation.elev3)
                    .cornerRadius(Radius.medium)
                }
            }.padding(.horizontal, GridLayout.side)
        } // background color ZStack
    } // body
}

struct RegisterNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNicknameView()
    }
}
