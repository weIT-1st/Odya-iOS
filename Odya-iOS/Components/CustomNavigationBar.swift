//
//  CustomNavigationBar.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/25.
//

import SwiftUI

struct CustomNavigationBar: View {
  @Environment(\.dismiss) var dismiss
    let title: String
    
    var body: some View {
        HStack {
            IconButton("direction-left") {
              dismiss()
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
