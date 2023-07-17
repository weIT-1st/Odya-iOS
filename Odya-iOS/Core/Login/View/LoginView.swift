//
//  LoginView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            Color.background.normal.ignoresSafeArea()
            
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
        } // main VStack
        
    } // ZStack (background color)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
