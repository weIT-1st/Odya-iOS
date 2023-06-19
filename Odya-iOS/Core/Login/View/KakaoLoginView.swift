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
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.black)
                        .padding(10)
                    Text("카카오 로그인")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 300, height: 44)
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
