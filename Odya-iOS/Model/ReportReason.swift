//
//  ReportReason.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/17.
//

import Foundation

/// 신고사유
enum ReportReason: CaseIterable {
  case spam
  case pornography
  case swearWord
  case overPost
  case copyrightViolation
  case infoLeak
  case other

  /// 신고 status: 서버 전송시 사용
  var status: String {
    switch self {
    case .spam:
      return "SPAM"
    case .pornography:
      return "PORNOGRAPHY"
    case .swearWord:
      return "SWEAR_WORD"
    case .overPost:
      return "OVER_POST"
    case .copyrightViolation:
      return "COPYRIGHT_VIOLATION"
    case .infoLeak:
      return "INFO_LEAK"
    case .other:
      return "OTHER"
    }
  }

  /// 신고 value: 뷰에 표시
  var value: String {
    switch self {
    case .spam:
      return "스팸 및 홍보글"
    case .pornography:
      return "음란성이 포함된 글"
    case .swearWord:
      return "욕설/생명경시/혐오/차별적인 글"
    case .overPost:
      return "게시글 도배"
    case .copyrightViolation:
      return "저작권 위배"
    case .infoLeak:
      return "개인정보 노출 및 불법 정보"
    case .other:
      return "기타"
    }
  }
}
