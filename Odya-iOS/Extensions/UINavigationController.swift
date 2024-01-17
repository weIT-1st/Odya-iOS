//
//  UINavigationController.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/20.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
  override open func viewDidLoad() {
    super.viewDidLoad()
    // 기본 내비게이션 바를 항상 가림 (최상단 내비게이션뷰에만 적용되는듯?)
    navigationBar.isHidden = true
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
