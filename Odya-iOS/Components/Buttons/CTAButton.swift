//
//  CTAButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/25.
//

import SwiftUI

extension View {
    func CTAButton(isActive: ButtonActiveSate, buttonStyle: ButtonStyleType,
                   labelText: String, labelSize: ComponentSizeType,
                   action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(labelText)
                .h6Style()
                .frame(width: labelSize.CTAButtonWidth)
                .padding(10)
        }.buttonStyle(CustomButtonStyle(state: isActive, style: buttonStyle))
        .disabled(isActive == .inactive)
    }
}
