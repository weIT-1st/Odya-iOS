//
//  GNBButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

extension View {
    
    /// Root Tab View 에 들어가는 TabItem 커스텀
    func GNBButton(iconImage: String, text: String) -> some View {
        VStack {
            Image(iconImage)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.odya.system.inactive)
                .padding(.bottom, 6)
            Text(text)
                .detail2Style()
                .foregroundColor(.odya.system.inactive)
        }
        .padding(10)
    }
    
    
}


