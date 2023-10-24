//
//  StarButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/10/10.
//

import SwiftUI


extension View {
    func StarButton(isActive: Bool, isYellowWhenActive: Bool,
                      action: @escaping () -> Void) -> some View {
        Button(action: action) {
            if isActive {
                Image(isYellowWhenActive ? "star-yellow" : "star-white")
            } else {
                Image("star-off")
            }
        }
    }
}
