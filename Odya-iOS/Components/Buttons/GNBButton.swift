//
//  GNBButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

extension View {
    
    /// Root Tab View 에 들어가는 TabItem 커스텀
    /// 근데 클릭 시 accentColor로 색이 변하는데 iconImage는 .foregroundColor로 색이 안바뀜..
    /// 고민....
    func GNBButton(iconImage: String, text: String) -> some View {
        VStack {
            Image(iconImage)
                .colorMultiply(.odya.system.inactive)
                .padding(.bottom, 6)
            Text(text)
                .detail2Style()
                .foregroundColor(.odya.system.inactive)
        }
        .padding(10)
    }
    
    
}


