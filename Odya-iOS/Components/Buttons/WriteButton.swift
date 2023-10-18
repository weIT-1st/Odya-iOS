//
//  WriteButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

//extension View {
//    func WriteButton(action: @escaping () -> Void) -> some View {
//        Button(action: action) {
//            Circle()
//                .fill(Color.odya.brand.primary)
//                .frame(width: 56, height: 56)
//                .floatingButtonShadow()
//                .overlay (
//                    Image("pen-m")
//                        .colorMultiply(.odya.label.r_normal)
//                )
//        }
//    }
//}

struct WriteButton: View {
    var body: some View {
        Circle()
            .fill(Color.odya.brand.primary)
            .frame(width: 56, height: 56)
            .floatingButtonShadow()
            .overlay (
                Image("pen-m")
                    .colorMultiply(.odya.label.r_normal)
            )
    }
}
