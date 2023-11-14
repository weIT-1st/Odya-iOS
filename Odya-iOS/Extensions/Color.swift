//
//  Color.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/03.
//

import SwiftUI
 
extension Color {
  /// 컬러 hex string을 Color 값으로 변환
  /// - Note: 기본 프로필 이미지 배경 색상 적용시 사용
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}
