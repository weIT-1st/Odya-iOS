//
//  Color.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/20.
//

import SwiftUI

extension Color {
    static let odya = OdyaColor()
    
//    // MARK: COLOR
//    static let brand        = BrandColor()
//    static let system       = SystemColor()
//
//    // MARK: GRAY
//    static let label        = LabelColor()
//    static let background   = BackgroundColor()
//    static let line         = LineColor()
//
//    // MARK: COLOR SCALE (BASE)
//    static let colorscale   = ColorScale()
//    static let grayscale    = GrayScale()
//    static let whiteopacity = WhiteOpacity()
//    static let blackopacity = BlackOpacity()
//
//    // MARK: ELEVATION
//    static let elevation    = ElevationColor()
}

struct OdyaColor {
    // MARK: COLOR
    let brand        = BrandColor()
    let system       = SystemColor()
    
    // MARK: GRAY
    let label        = LabelColor()
    let background   = BackgroundColor()
    let line         = LineColor()
    
    // MARK: COLOR SCALE (BASE)
    let colorscale   = ColorScale()
    let grayscale    = GrayScale()
    let whiteopacity = WhiteOpacity()
    let blackopacity = BlackOpacity()
    
    // MARK: ELEVATION
    let elevation    = ElevationColor()
}

struct BrandColor {
    let primary     = Color("base-yellow-50")
    let secondary   = Color("base-yellow-30")
    let tertiary    = Color("base-blue-50")
}

struct SystemColor {
    let warning             = Color("warning")
    let warningAlternative  = Color("warning_alternative")
    let safe                = Color("safe")
    let safeAlternative     = Color("safe_alternative")
    let inactive            = Color("inactive")
}

struct LabelColor {
    let normal      = Color("base-gray-0")
    let alternative = Color("base-gray-80")
    let assistive   = Color("base-gray-50")
    let inactive    = Color("base-gray-30")
    let r_normal    = Color("base-gray-50")
    let r_assistive = Color("base-gray-40")
}

struct BackgroundColor {
    let normal          = Color("base-gray-100")
    let dimmed_system   = Color("base-gray-50")
    let dimmed_dark     = Color("base-gray-70")
    let dimmed_light    = Color("base-gray-20")
}

struct LineColor {
    let normal      = Color("base-white-alpha-40")
    let alternative = Color("base-white-alpha-10")
}

struct ColorScale {
    let baseYellow20 = Color("base-yellow-20")
    let baseYellow30 = Color("base-yellow-30")
    let baseYellow40 = Color("base-yellow-40")
    let baseYellow50 = Color("base-yellow-50")
    let baseYellow60 = Color("base-yellow-60")
    let baseYellow70 = Color("base-yellow-70")
    
    let baseBlue20 = Color("base-blue-20")
    let baseBlue30 = Color("base-blue-30")
    let baseBlue40 = Color("base-blue-40")
    let baseBlue50 = Color("base-blue-50")
    let baseBlue60 = Color("base-blue-60")
    let baseBlue70 = Color("base-blue-70")
}

struct GrayScale {
    let baseGray100 = Color("base-gray-100")
    let baseGray90  = Color("base-gray-90")
    let baseGray80  = Color("base-gray-80")
    let baseGray70  = Color("base-gray-70")
    let baseGray60  = Color("base-gray-60")
    let baseGray50  = Color("base-gray-50")
    let baseGray40  = Color("base-gray-40")
    let baseGray30  = Color("base-gray-30")
    let baseGray20  = Color("base-gray-20")
    let baseGray10  = Color("base-gray-10")
    let baseGray5   = Color("base-gray-5")
    let baseGray0   = Color("base-gray-0")
}

struct WhiteOpacity {
    let baseWhiteAlpha90 = Color("base-white-alpha-90")
    let baseWhiteAlpha80 = Color("base-white-alpha-80")
    let baseWhiteAlpha70 = Color("base-white-alpha-70")
    let baseWhiteAlpha60 = Color("base-white-alpha-60")
    let baseWhiteAlpha50 = Color("base-white-alpha-50")
    let baseWhiteAlpha40 = Color("base-white-alpha-40")
    let baseWhiteAlpha30 = Color("base-white-alpha-30")
    let baseWhiteAlpha20 = Color("base-white-alpha-20")
    let baseWhiteAlpha10 = Color("base-white-alpha-10")
    let baseWhiteAlpha5  = Color("base-white-alpha-5")
}

struct BlackOpacity {
    let baseBlackAlpha90 = Color("base-black-alpha-90")
    let baseBlackAlpha80 = Color("base-black-alpha-80")
    let baseBlackAlpha70 = Color("base-black-alpha-70")
    let baseBlackAlpha60 = Color("base-black-alpha-60")
    let baseBlackAlpha50 = Color("base-black-alpha-50")
    let baseBlackAlpha40 = Color("base-black-alpha-40")
    let baseBlackAlpha30 = Color("base-black-alpha-30")
    let baseBlackAlpha20 = Color("base-black-alpha-20")
    let baseBlackAlpha10 = Color("base-black-alpha-10")
    let baseBlackAlpha5  = Color("base-black-alpha-5")
}

struct ElevationColor {
    let elev1 = Color("base-gray-100")
    let elev2 = Color("base-gray-90")
    let elev3 = Color("base-gray-80")
    let elev4 = Color("base-gray-70")
    let elev5 = Color("base-gray-60")
    let elev6 = Color("base-gray-50")
}
