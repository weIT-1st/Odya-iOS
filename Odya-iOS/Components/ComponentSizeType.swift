//
//  ComponentSizeType.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/07/27.
//

import SwiftUI

enum ComponentSizeType: String {
    case XL
    case L
    case M
    case S
    
    var CTAButtonWidth: CGFloat? {
        switch self {
        case .L:
            return 300
        case .M:
            return 260
        case .S:
            return 120
        default:
            return 300
        }
    }
    
    var ProfileImageSize: CGFloat {
        switch self {
        case .XL:
            return 96
        case .L:
            return 64
        case .M:
            return 32
        case .S:
            return 24
        }
    }
}