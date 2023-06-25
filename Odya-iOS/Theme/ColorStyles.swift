//
//  Color.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/20.
//

import SwiftUI

extension Color {
    // MARK: COLOR
    static let brandColor   = BrandColor()
    static let colorScale   = ColorScale()
    static let system       = System()
    
    // MARK: GRAY SCALE
    static let background   = Background()
    static let label        = Label()
    static let line         = Line()
    
    // MARK: ELEVATION
    static let elevation    = Elevation()
}

//struct OdyaColor {
//    // MARK: COLOR
//    static let brand        = ColorBrand()
//    static let colorScale   = ColorScale()
//    static let system       = ColorSystem()
//
//    // MARK: GRAY SCALE
//    static let background   = ColorBackground()
//    static let label        = ColorLabel()
//    static let line         = ColorLine()
//}

struct BrandColor {
    let primary     = Color("primary")
    let secondary   = Color("secondary")
    let tertiary    = Color("tertiary")
}

struct ColorScale {
    let yellow20 = Color("yellow20")
    let yellow30 = Color("yellow30")
    let yellow40 = Color("yellow40")
    let yellow50 = Color("yellow50")
    let yellow60 = Color("yellow60")
    let yellow70 = Color("yellow70")
    
    let blue20 = Color("blue20")
    let blue30 = Color("blue30")
    let blue40 = Color("blue40")
    let blue50 = Color("blue50")
    let blue60 = Color("blue60")
    let blue70 = Color("blue70")
}

struct System {
    let warning             = Color("warning")
    let warningAlternative  = Color("warning_alternative")
    let safe                = Color("safe")
    let safeAlternative     = Color("safe_alternative")
    let inactive            = Color("inactive")
}

struct Background {
    let normal = Color("bg_normal")
    let dimmed = Color("bg_dimmed")
}

struct Label {
    let normal      = Color("label_normal")
    let alternative = Color("label_alternative")
    let assistive   = Color("label_assistive")
    let inactive    = Color("label_inactive")
    let r_normal    = Color("r_normal")
    let r_assistive = Color("r_assistive")
}

struct Line {
    let normal      = Color("line_normal")
    let alternative = Color("line_alternative")
}

struct Elevation {
    let elev1 = Color("elev1")
    let elev2 = Color("elev2")
    let elev3 = Color("elev3")
    let elev4 = Color("elev4")
    let elev5 = Color("elev5")
    let elev6 = Color("elev6")
}
