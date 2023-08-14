//
//  ProfileView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/19.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        UserInfoEditView(userInfo: UserInfo(nickname: "길동아밥먹자"))
                .navigationBarHidden(true)
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
