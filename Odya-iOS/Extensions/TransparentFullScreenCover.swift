//
//  TransparentFullScreenCover.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/07.
//
//
//import SwiftUI
//
//extension View {
//  func transparentFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
//    fullScreenCover(isPresented: isPresented) {
//      ZStack {
//        content()
//      }
//      .background(TransparentBackground())
//    }
//  }
//}
//
//struct TransparentBackground: UIViewRepresentable {
//  func makeUIView(context: Context) -> UIView {
//    let view = UIView()
//    DispatchQueue.main.async {
//      view.superview?.superview?.backgroundColor = .clear
//    }
//    return view
//  }
//  
//  func updateUIView(_ uiView: UIView, context: Context) {}
//}
