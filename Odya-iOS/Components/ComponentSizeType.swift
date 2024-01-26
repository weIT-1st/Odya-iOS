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
    case XS
    
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
            return 40
        case .S:
            return 32
        case .XS:
            return 24
        }
    }
    
    var FishchipButtonHeight: CGFloat {
        switch self {
        case .M:
            return 32
        case .S:
            return 28
        default:
            return 24
        }
    }
  
  var StarRatingSize: CGFloat {
    switch self {
    case .M:  // 한줄리뷰 작성, 장소 상세보기 평균 별점
      return 40
    case .S:  // 여행일지, 장소 상세보기 각 리뷰 별점
      return 17
    default:
      return 17
    }
  }
}
