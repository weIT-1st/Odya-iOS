//
//  HTMLTextView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/14.
//

import WebKit
import SwiftUI

struct HTMLTextView: UIViewRepresentable {
  let htmlContent: String
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(htmlContent, baseURL: nil)
  }
}
