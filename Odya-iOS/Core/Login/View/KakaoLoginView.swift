//
//  KakaoLoginView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/05/31.
//

import SwiftUI

struct KakaoLoginView: View {
    
    // MARK: PROPERTIES
    @StateObject var kakaoAuthViewModel = KakaoAuthViewModel()
    
    // MARK: BODY
    var body: some View {
        VStack {
            // login button
            Button(action: {kakaoAuthViewModel.kakaoLogin()}) {
                HStack(spacing: 0) {
                    Image("kakao-icon")
                        .resizable()
                        .scaledToFit()
                        .padding(10)
                    Text("카카오 로그인")
                        .b1Style()
                        .foregroundColor(.black)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 44)
                .padding(.horizontal, 8)
                .background(Color("kakao-yellow"))
                .cornerRadius(Radius.small)
            }
        }
    }
}


// MARK: PREVIEWS
struct KakaoLoginView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginView()
    }
}
