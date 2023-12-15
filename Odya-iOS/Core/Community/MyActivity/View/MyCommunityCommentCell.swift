//
//  MyCommunityCommentCell.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/12/15.
//

import SwiftUI

struct MyCommunityCommentCell: View {
  var body: some View {
    HStack(alignment: .top, spacing: 9) {
      // TODO: replace profile image
      Circle()
        .frame(width: 32, height: 32)
      
      VStack(spacing: 10) {
        // feed
        simpleFeedContent
        
        // comment
        HStack(alignment: .top, spacing: 10) {
          // TODO: replace profile image
          Circle()
            .frame(width: 32, height: 32)
          simpleCommentContent
        }
      }
    }
  }
  
  /// 간략한 피드 내용
  private var simpleFeedContent: some View {
    HStack(alignment: .center, spacing: 10) {
      VStack(alignment: .leading, spacing: 7) {
        // feed writer nickname
        HStack(alignment: .center) {
          Text("길동아밥먹자아아")
            .b1Style()
            .foregroundColor(.odya.label.normal)
          // feed content
          Text("피드 게시글 내용 피드 게시글 내용 피드 게시글 내용")
            .detail2Style()
            .foregroundColor(.odya.label.normal)
            .lineLimit(1)
        }
        // TODO: change date format
        Text("2일전")
          .detail1Style()
          .foregroundColor(.odya.label.assistive)
      }
      // replace main image
      Rectangle()
        .frame(width: 60, height: 60)
    }
  }
  
  /// 간략한 댓글 내용
  private var simpleCommentContent: some View {
    VStack(alignment: .leading, spacing: 20) {
      // comment writer nickname
      HStack {
        Text("길동아밥먹자")
          .b1Style()
          .foregroundColor(.odya.label.normal)
        Spacer()
      }
      VStack(alignment: .leading, spacing: 4) {
        // comment content
        Text("형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다. 그런데 형제도 형제 나름이다.충청. 전라. 경상의 삼도가 만나는 어름에 사는 연생원이라")
          .detail2Style()
          .foregroundColor(.odya.label.normal)
          .lineLimit(3)
          .multilineTextAlignment(.leading)
        // TODO: change date format
        HStack {
          Text("2일전")
            .detail1Style()
            .foregroundColor(.odya.label.assistive)
          Spacer()
        }
      }
    }
    .padding(.vertical, 4)
  }
}

struct MyCommunityCommentCell_Previews: PreviewProvider {
  static var previews: some View {
    MyCommunityCommentCell()
      .frame(height: 200)
  }
}
