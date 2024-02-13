//
//  CommunityLikeButton.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/23.
//

import SwiftUI

enum HeartImage: String {
  case mOff = "heart-off-m"
  case lOn = "heart-on-l"
  case sOn = "heart-on-s"
  case sOff = "heart-off-s"
  
  func nextOn() -> HeartImage {
    switch self {
    case .mOff: return .lOn
    case .lOn: return .sOn
    default: return .sOn
    }
  }
  
  func nextOff() -> HeartImage {
    switch self {
    case .sOn: return .sOff
    case .sOff: return .mOff
    default: return .mOff
    }
  }
}

struct CommunityLikeButton: View {
  @StateObject private var likeViewModel = CommunityLikeViewModel()
  
  let communityId: Int
  @State var likeState: Bool
  @State var likeCount: Int
  @State private var likeImageName = HeartImage.mOff
  let baseColor: Color
  
    var body: some View {
      HStack(spacing: 4) {
        Button {
          if likeState {
            withAnimation(.spring()) {
              // 좋아요 삭제
              likeCount -= 1
              likeViewModel.deleteLike(communityId: communityId)
              
              likeImageName = likeImageName.nextOff()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                likeImageName = likeImageName.nextOff()
              }
              likeState = false
            }
          } else {
            withAnimation(.spring()) {
              // 좋아요 생성
              likeCount += 1
              likeViewModel.createLike(communityId: communityId)
              
              likeImageName = likeImageName.nextOn()
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                likeImageName = likeImageName.nextOn()
              }
              likeState = true
            }
          }

        } label: {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 24, height: 40)
            .background(
              likeImage(state: likeState)
            )
        }
        
        // 좋아요 수
        Text(likeCount > 99 ? "99+" : "\(likeCount)")
          .detail1Style()
          .foregroundColor(baseColor)
      }
      .onAppear {
        likeImageName = likeState ? HeartImage.sOn : HeartImage.mOff
      }
    }
  
  private func likeImage(state: Bool) -> some View {
    Image(likeImageName.rawValue)
      .resizable()
      .renderingMode(state ? .original : .template)
      .foregroundColor(state ? .clear : baseColor)
      .aspectRatio(contentMode: .fit)
      .frame(width: 24, height: 40)
  }
}
