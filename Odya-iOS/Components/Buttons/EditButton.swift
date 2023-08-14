//
//  EditButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/25.
//

import SwiftUI

extension View {
    /// 여행일지 글쓰기 버튼
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
    
    /// 유저 정보 변경 버튼
    func UserInfoEditButton(buttonText: String,
                            isActive: Bool,
                            action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(buttonText)
                .h6Style()
                .foregroundColor(isActive ? .odya.label.r_normal : .odya.label.inactive)
                .padding(12)
        }.disabled(isActive)
            .background(isActive ? Color.odya.brand.primary : Color.odya.system.inactive)
            .cornerRadius(Radius.medium)
    }
}
