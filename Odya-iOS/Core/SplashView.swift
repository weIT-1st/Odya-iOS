//
//  SplashView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/26.
//

import Foundation
import SwiftUI
import UIKit
import Lottie

/// 스플래쉬 애니메이션 뷰
/// 로티 이용
struct SplashView: UIViewRepresentable {
  
  var name: String
  var loopMode: LottieLoopMode
  
  init(jsonName: String = "SplashScreenAnimation",
       _ loopMode : LottieLoopMode = .loop){
    print("LottieView - init() called / jsonName: ", jsonName)
    self.name = jsonName
    self.loopMode = loopMode
  }
  
  func makeUIView(context: Context) -> Lottie.LottieAnimationView {
    print("LottieView - makeUIView() called")
    
    let animationView = LottieAnimationView(name: name)
    
    // AspectFit으로 적절한 크기의 애니메이션을 불러옴
    animationView.contentMode = .scaleAspectFit
    // 애니메이션 loop 방식 - 기본이 .loop
    animationView.loopMode = loopMode
    // 애니메이션 재생
    animationView.play()
    // 백그라운드에서 재생이 멈추는 오류 해결
    animationView.backgroundBehavior = .pauseAndRestore
    
    return animationView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    print("LottieView - updateUIView() called")
  }
}
