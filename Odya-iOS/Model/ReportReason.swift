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
  case swear_word
  case over_post
  case info_leak
  case other
  
  /// 신고 status: 서버 전송시 사용
  var status: String {
    switch self {
    case .spam:
      return "SPAM"
    case .pornography:
      return "PORNOGRAPHY"
    case .swear_word:
      return "SWEAR_WORD"
    case .over_post:
      return "OVER_POST"
    case .info_leak:
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
    case .swear_word:
      return "욕설/생명경시/혐오/차별적인 글"
    case .over_post:
      return "게시글 도배"
    case .info_leak:
      return "개인정보 노출 및 불법 정보"
    case .other:
      return "기타"
    }
  }
}
