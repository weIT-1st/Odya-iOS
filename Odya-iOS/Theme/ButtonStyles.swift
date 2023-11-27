//
//  ButtonStyles.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/24.
//

import SwiftUI

enum ButtonStyleType {
    case solid
    case ghost
    case basic
}

enum ButtonActiveSate {
    case active
    case inactive
}

struct CustomButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = Radius.medium
    let state: ButtonActiveSate
    let style: ButtonStyleType
    
    private func activeSolid(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.odya.label.r_normal)
            .background(Color.odya.brand.primary)
            .cornerRadius(cornerRadius)
    }
    
    private func activeGhost(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.odya.brand.primary)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.odya.brand.primary, lineWidth: 1)
            )
    }
    
    private func inactive(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.odya.label.inactive)
            .background(Color.odya.system.inactive)
            .cornerRadius(cornerRadius)
    }
  
    private func activeBasic(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.odya.label.assistive)
            .background(Color.odya.elevation.elev2)
            .cornerRadius(cornerRadius)
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        switch state {
        case .active:
            switch style {
            case .solid:
                activeSolid(configuration: configuration)
            case .ghost:
                activeGhost(configuration: configuration)
            case .basic:
                activeBasic(configuration: configuration)
            }
        case .inactive:
            inactive(configuration: configuration)
        }
    }
}

