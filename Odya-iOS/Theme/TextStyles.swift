//
//  View.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/21.
//

import SwiftUI

enum FontWeight {
    case bold
    case regular
}

struct LogoFontStyle {
    let size: CGFloat
    let weight: FontWeight
    let lineHeight: CGFloat
}

extension Font {
    static func notoSansKRStyle(_ style: LogoFontStyle) -> Font {
        let fontName: String
        switch style.weight {
        case .bold:
            fontName = "NotoSansKR-Bold"
        case .regular:
            fontName = "NotoSansKR-Regular"
        }
        return Font.custom(fontName, size: style.size)
    }
}

extension View {
    private func applyTextStyle(style: LogoFontStyle) -> some View {
        self.font(Font.notoSansKRStyle(style)).lineSpacing((style.lineHeight - 1) * style.size)
    }

    func h1Style() -> some View {
        let style = LogoFontStyle(size: 36, weight: .bold, lineHeight: 1.3)
        return applyTextStyle(style: style)
    }

    func h2Style() -> some View {
        let style = LogoFontStyle(size: 32, weight: .bold, lineHeight: 1.3)
        return applyTextStyle(style: style)
    }

    func h3Style() -> some View {
        let style = LogoFontStyle(size: 24, weight: .bold, lineHeight: 1.3)
        return applyTextStyle(style: style)
    }

    func h4Style() -> some View {
        let style = LogoFontStyle(size: 22, weight: .bold, lineHeight: 1.3)
        return applyTextStyle(style: style)
    }

    func h5Style() -> some View {
        let style = LogoFontStyle(size: 20, weight: .bold, lineHeight: 1.4)
        return applyTextStyle(style: style)
    }

    func h6Style() -> some View {
        let style = LogoFontStyle(size: 18, weight: .bold, lineHeight: 1.4)
        return applyTextStyle(style: style)
    }

    func b1Style() -> some View {
        let style = LogoFontStyle(size: 16, weight: .bold, lineHeight: 1.7)
        return applyTextStyle(style: style)
    }

    func b2Style() -> some View {
        let style = LogoFontStyle(size: 16, weight: .regular, lineHeight: 1.7)
        return applyTextStyle(style: style)
    }

    func detail1Style() -> some View {
        let style = LogoFontStyle(size: 12, weight: .bold, lineHeight: 1.5)
        return applyTextStyle(style: style)
    }

    func detail2Style() -> some View {
        let style = LogoFontStyle(size: 12, weight: .regular, lineHeight: 1.5)
        return applyTextStyle(style: style)
    }
    
}
