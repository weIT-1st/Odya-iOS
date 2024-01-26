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
    let backgroundColor: UIColor
    let textColor: UIColor
    let font: UIFont

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        applyStyles(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
        applyStyles(uiView)
    }

    private func applyStyles(_ webView: WKWebView) {
        let style = """
            <style>
                body {
                    background-color: \(backgroundColor.hexString ?? "#FFFFFF");
                    color: \(textColor.hexString ?? "#000000");
                    font-family: \(font.familyName), \(font.fontName);
                    font-size: \(font.pointSize)pt;
                }
            </style>
        """

        if let url = URL(string: "about:blank") {
            let styledHTML = "<html><head>\(style)</head><body>\(htmlContent)</body></html>"
            webView.loadHTMLString(styledHTML, baseURL: url)
        }
    }
}

struct HTMLTextView_Previews: PreviewProvider {
    static var previews: some View {
        HTMLTextView(htmlContent: "<h1>어쩌구 저쩌구 어쩌구 저쩌구</h1>",
                     backgroundColor: UIColor(.odya.background.normal),
                     textColor: UIColor(.odya.label.normal),
                     font: UIFont(name: "NotoSansKR-Bold", size: 36)!
        ).previewLayout(.sizeThatFits)
    }
}

extension UIColor {
    var hexString: String? {
        let components = self.cgColor.components
        guard components != nil && components!.count >= 3 else { return nil }

        let red = Int(components![0] * 255.0)
        let green = Int(components![1] * 255.0)
        let blue = Int(components![2] * 255.0)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}
