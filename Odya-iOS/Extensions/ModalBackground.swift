//
//  ClearBackground.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/27.
//

import SwiftUI

private struct ModalBackgroundView: UIViewRepresentable {
    var color: UIColor = .clear
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = color
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

private struct ModalBackgroundViewColorModifier: ViewModifier {
    var color: Color = .clear
    
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content
                .presentationBackground(color)
        } else {
            content
                .background(ModalBackgroundView(color: UIColor(color)))
        }
    }
}

extension View {
    func clearModalBackground() -> some View {
        self.modifier(ModalBackgroundViewColorModifier())
    }
    
    func setModalBackground(_ color: Color) -> some View {
        self.modifier(ModalBackgroundViewColorModifier(color: color))
    }
}
