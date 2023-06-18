//
//  LoginView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/05/26.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            KakaoLoginView()
            AppleLoginButton()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
