//
//  CustomNavigationBar.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.presentationMode) private var presentationMode
    let title: String
    
    var body: some View {
        HStack {
            IconButton("direction-left") {
                presentationMode.wrappedValue.dismiss() // 뒤로 이동 기능 수행
            }
            Spacer()
            Text(title)
                .h6Style()
                .foregroundColor(.odya.label.normal)
            Spacer()
            IconButton("direction-right") {}.disabled(true)
                .colorMultiply(.clear)
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
    }
}
