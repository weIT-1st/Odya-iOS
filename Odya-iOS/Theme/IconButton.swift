//
//  iconButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/24.
//

import SwiftUI

extension View {
    func IconButton(_ iconImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(iconImage)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(6)
        }
    }
}
