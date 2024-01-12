//
//  Terms.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/14.
//

import Foundation

// MARK: - Terms
struct Terms: Codable {
  let id: Int
  let title: String
  let isRequired: Bool

  enum CodingKeys: String, CodingKey {
    case id, title
    case isRequired = "required"
  }
}

typealias TermsList = [Terms]

// MARK: - TermsContent
struct TermsContent: Codable {
  let id: Int
  let content: String
}
