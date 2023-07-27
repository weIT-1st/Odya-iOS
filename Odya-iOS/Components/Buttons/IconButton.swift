//
//  iconButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/24.
//

import SwiftUI

//extension Image {
//
//    /// 아이콘 이미지, size, color 를 이용해 커스텀 할 수 있음.
//    /// 크기는 height기준으로 size에 맞춰지며, 기본 사이즈는 24.
//    /// 색깔은 color로 설정할 수 있으며, 기본 색은 label/normal.
//    func icon(size: CGFloat? = 24, color: Color = .odya.label.normal) -> some View {
//        self
//            .resizable()
//            .scaledToFit()
//            .frame(height: size)
//            .colorMultiply(color)
//    }
//}

extension View {
    
    /// 커스텀 아이콘 버튼
    /// iconImage를 이미지로 하며 클릭 시 action을 실행하는 버튼
    func IconButton(_ iconImage: String,
                    action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(iconImage)
                .padding(6)
        }
    }
}


