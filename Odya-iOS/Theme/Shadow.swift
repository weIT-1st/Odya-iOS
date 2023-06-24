//
//  Shadow.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/21.
//

import SwiftUI


extension View {
    func cardShadow() -> some View {
        self.compositingGroup()
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 8)
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 2)
    }
    
    func floatingButtonShadow() -> some View {
        self.compositingGroup()
            .shadow(color: Color.black.opacity(0.08), radius: 28, x: 4, y: 8)
            .shadow(color: Color.black.opacity(0.16), radius: 12, x: 0, y: 4)
    }
    
    func profileShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 0)
    }
    
    func dropBoxShadow() -> some View {
        self.compositingGroup()
            .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 0)
    }
    
    func etcShadow() -> some View {
        self.compositingGroup()
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 2, y: 2)
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 0)
    }
}
