//
//  CheckBoxButton.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/23.
//

import SwiftUI

enum checkboxState {
    case disabled
    case unselected
    case selected
}

struct CheckboxButton: View {
    @Binding var state: checkboxState
    
    var body: some View {
        Button(action: {
//            if state == .unselected {
//                state = .selected
//            } else if state == .selected{
//                state = .unselected
//            }
        }, label: {
            ZStack {
                VStack {
                    switch state{
                    case .disabled:
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.odya.elevation.elev6)
                    case .unselected:
                        RoundedRectangle(cornerRadius: 2)
                            .inset(by: 1)
                            .stroke(Color.odya.brand.primary, lineWidth: 2)
                    case .selected:
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.odya.brand.primary)
                    }
                }.frame(width: 18, height: 18)
                    
                Image("check-s")
            }
        }).disabled(state == .disabled)
    }
}

