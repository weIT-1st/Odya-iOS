//
//  LoginView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appleAuthVM: AppleAuthViewModel
    @EnvironmentObject var kakaoAuthVM: KakaoAuthViewModel
    
    var body: some View {
        ZStack {
            Color.odya.background.normal.ignoresSafeArea()
            
            if appleAuthVM.isUnauthorized == false
                && kakaoAuthVM.isUnauthorized == false {
                VStack {
                    Spacer()
                    
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                        Image("catch phrase")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, GridLayout.columnWidth)
                    }.padding(.horizontal, GridLayout.columnWidth + GridLayout.spacing)
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 8) {
                        KakaoLoginButton()
                        AppleLoginButton()
                    }.padding(.bottom, 60)
                }.padding(.horizontal, GridLayout.side)
            } else {
                if appleAuthVM.isUnauthorized {
                    SignUpView(userInfo: appleAuthVM.userInfo)
                } else {
                    SignUpView(userInfo: kakaoAuthVM.userInfo)
                }
            }
        }
        
    } // ZStack (background color)

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
