//
//  FieldStyle.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct CustomFieldStyle: ViewModifier {
    var height: CGFloat = 48
    var backgroundColor: Color = Color.odya.elevation.elev3
    var radius: CGFloat = Radius.medium
    func body(content: Content) -> some View {
        content
            .frame(height: height)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(radius)
    }
}
    
/// UserInfo를 입력받는 텍스트 필드
/// 필드에 입력값이 있을 경우, 입력값을 지우는 x버튼이 제공됨
/// 필드에 값을 입력 중인 경우, 입력값이 유효한 형식인지 표시됨
struct UserInfoTextField: View {
    let info: String
    @Binding var newInfo: String
    let infoField: UserInfoField
    
    private var isInfoEditing: Bool {
        info != newInfo
    }
    private var isValid: Bool {
        infoField.isValid(value: newInfo)
    }
    
    var body: some View {
        HStack {
            TextField(newInfo == "" ? infoField.textFieldDefaultMessage() : newInfo, text: $newInfo)
                .foregroundColor(info != newInfo ? .odya.label.normal : .odya.label.inactive)
                .b1Style()
                
            if isInfoEditing {
                Image(isValid ? "system-check-circle": "system-warning")
            } else if newInfo != "" {
                IconButton("smallGreyButton-x") {
                    newInfo = ""
                }
            }
        }
        .modifier(CustomFieldStyle())
    }
}
