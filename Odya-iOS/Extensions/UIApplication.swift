//
//  UIApplication.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/10/20.
//

import UIKit

extension UIApplication {
    /// Tap gesture로 키보드 내리기
    func hideKeyboardOnTap() {
        guard let window = (connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.delegate = self
        window.addGestureRecognizer(tapRecognizer)
    }
 }
 
extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
