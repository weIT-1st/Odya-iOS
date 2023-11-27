//
//  MainView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/03.
//

import SwiftUI
import KakaoSDKUser

struct MainView: View {
    @StateObject var kakaoAuthViewModel = KakaoAuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()
                
                // 사용자 정보 - 프로필 닉네임
//                Text(getUserName())
                
                // logout button
                Button(action: {
                    kakaoAuthViewModel.kakaoLogout()}) {
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
        .onAppear{
            // 메인 화면이 시작될 때 사용자 정보 초기화
//            kakaoAuthViewModel.getUserInfoFromKakao()
        }
            
    }
    
    // MARK: FUNCTIONS
    
    /// 화면에 표시할 카카오 프로필 닉네임 가져오기
//    func getUserName() -> String {
//        let kakaoUser = kakaoAuthViewModel.userInfo
//
//        guard let user = kakaoUser else {
//            return "no user"
//        }
//        guard let account = user.kakaoAccount else {
//            return "no account"
//        }
//        guard let nickname = account.profile?.nickname else {
//            return "no nickname"
//        }
//        return nickname
//    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
