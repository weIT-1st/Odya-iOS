//
//  ToggleButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    let onColor = Color.odya.brand.primary
    let offColor = Color.odya.system.inactive
    let size = CGSize(width: 51, height: 31)
    
    func makeBody(configuration: Configuration) -> some View {
        let isOn = configuration.isOn
        return HStack {
            configuration.label
            Spacer()
            ZStack(alignment: isOn ? .trailing : .leading) {
                RoundedRectangle(cornerRadius: size.height / 2)
                    .fill(isOn ? onColor : offColor)
                Circle()
                    .foregroundColor(.white)
                    .dropBoxShadow()
                    .padding(2)
            }
            .frame(width: size.width, height: size.height)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
