//
//  FeedCommentView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/15.
//

import SwiftUI

struct FeedCommentView: View {
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 24) {
            // full comment button
            Button {
                // action: open bottom sheet
            } label: {
                HStack(spacing: 10) {
                    Text("12개의 댓글 더보기")
                        .detail1Style()
                        .foregroundColor(Color.odya.label.assistive)
                    // image >
                }
                .padding(.vertical, 8)
                .frame(height: 36)
                .frame(maxWidth: .infinity)
                .background(Color.odya.elevation.elev3)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .inset(by: 0.5)
                        .stroke(Color.odya.line.alternative, lineWidth: 1)
                )
            }

            // comments top 2
            VStack(spacing: 16) {
                FeedCommentCell()
                
                Divider()
                
                FeedCommentCell()
            }
            
            // write comment btn or tf
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, GridLayout.side)
        .background(Color.odya.elevation.elev2)
        .clipShape(RoundedEdgeShape(edgeType: .top, cornerRadius: Radius.large))
    }
}

// MARK: - FeedCommentCell

struct FeedCommentCell: View {
    var body: some View {
        VStack(spacing: 12) {
            // user, menu
            HStack {
                HStack(spacing: 12) {
                    // profile image
                    // nickname
                    Text("닉네임")
                        .b1Style()
                        .foregroundColor(Color.odya.label.alternative)
                }
                Spacer()
                IconButton("menu-kebob") {
                    
                }
                .frame(width: 24, height: 24)
            }
            
            // comment text
            Text("형제는 오륜의 하나요, 한 몸을 쪼갠 것이다. 그러므로 부귀와 화복을 같이 하는 것이다.")
                .detail2Style()
                .foregroundColor(Color.odya.label.assistive)
                .frame(alignment: .topLeading)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
        }
    }
}

// MARK: - Preview

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedCommentView()
    }
}
