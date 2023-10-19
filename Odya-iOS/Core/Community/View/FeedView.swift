//
//  FeedView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/08/10.
//

import SwiftUI

struct FeedView: View {
  // MARK: - Body

  var body: some View {
    NavigationView {
      ZStack(alignment: .bottomTrailing) {
        VStack {
          // tool bar
          // TODO: - 툴바 디자인 변경예정
          FeedToolBar()

          // scroll view
          ScrollView {
            VStack {
              // fishchips
              FishchipsBar()

              // posts (무한)
              ForEach(0..<10) { _ in
                NavigationLink {
                  FeedDetailView()
                } label: {
                  PostView()
                    .padding(.bottom, 8)
                }
              }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .refreshable {
            // fetch new posts
          }
          .onAppear {
            customRefreshControl()
          }
        }
        .background(Color.odya.background.normal)

//        WriteButton {
          // action: 작성하기 뷰
//        }
        .padding(20)
      }  // ZStack
    }
  }

  func customRefreshControl() {
    UIRefreshControl.appearance().tintColor = .clear
    UIRefreshControl.appearance().backgroundColor = UIColor(Color.odya.brand.primary)
    let attribute = [
      NSAttributedString.Key.foregroundColor: UIColor(Color.odya.label.r_assistive),
      NSAttributedString.Key.font: UIFont(name: "KIMM_Bold", size: 16),
    ]
    UIRefreshControl.appearance().attributedTitle = NSAttributedString(
      string: "피드에 올린 곳 오댜?", attributes: attribute as [NSAttributedString.Key: Any])
  }
}

struct CustomRepreshView: View {

  var body: some View {
    Text("피드에 올린 곳 오댜?")
      .foregroundColor(Color.odya.label.r_assistive)
      .background(Color.odya.brand.primary)
      .frame(maxWidth: .infinity)
      .frame(height: 60)
  }
}

// MARK: - Preview

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
