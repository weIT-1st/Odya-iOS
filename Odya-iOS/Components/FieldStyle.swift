//
//  FieldStyle.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/03.
//

import SwiftUI

struct CustomFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color.odya.elevation.elev3)
            .cornerRadius(Radius.medium)
    }
}
    
