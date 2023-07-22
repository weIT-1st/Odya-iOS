//
//  iconButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/24.
//

import SwiftUI

extension View {
    func IconButton(_ iconImage: String, size: CGFloat? = 24, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(iconImage)
                .resizable()
                .scaledToFit()
                .frame(height: size) // location-s의 경우 정사각형이 아님
                .padding(6)
        }
    }
}
