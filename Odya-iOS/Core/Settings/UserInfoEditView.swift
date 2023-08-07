//
//  UserInfoEditView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/07.
//

import SwiftUI

struct UserInfoEditView: View {
    var body: some View {
        ZStack {
            Color.odya.background.normal.ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Group { // nickname
                    Text("닉네임")
                        .h6Style()
                        .foregroundColor(.odya.label.normal)
                    HStack {
                        
                    }
                    
                }
                
                Group { // phoen number
                    
                }
                
                Group { // email
                    
                }
                
                Group { // logout
                    
                }
                
                Group { // unregister
                    
                }
            }.padding(.horizontal, GridLayout.side)
        } // background ZStack
    }
}

struct UserInfoEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoEditView()
    }
}
