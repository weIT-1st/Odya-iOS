//
//  EditButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/25.
//

import SwiftUI

extension View {
    func EditButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("편집하기")
                .detail1Style()
                .foregroundColor(.odya.label.alternative)
                .padding(8)
        }.background(Color.odya.elevation.elev3)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.small)
                    .inset(by: 0.5)
                    .stroke(Color.odya.line.alternative, lineWidth: 1)
            )
    }
}
