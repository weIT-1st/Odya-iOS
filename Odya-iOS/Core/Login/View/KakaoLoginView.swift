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
    
    /// 로그인 상태 정보
    let loginStatusInfo: (Bool) -> String = { isLoggedIn in
        return isLoggedIn ? "로그인 상태" : "로그아웃 상태"
    }
    
    // MARK: BODY
    var body: some View {
        VStack {
            // 카카오 로그인 상태 정보 표시
            Text(loginStatusInfo(kakaoAuthViewModel.isLoggedIn))
            
            // login button
            Button(action: {kakaoAuthViewModel.kakaoLogin()}) {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.black)
                        .padding(10)
                    Text("카카오 로그인")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 300, height: 45)
                .padding(.horizontal, 10)
                .background(.yellow)
                .cornerRadius(4)
            }
            
            // logout button
            Button(action: {kakaoAuthViewModel.kakaoLogout()}) {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.black)
                        .padding(10)
                    Text("로그아웃")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 300, height: 45)
                .padding(.horizontal, 10)
                .background(.yellow)
                .cornerRadius(4)
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
