//
//  FeedFullCommentSheet.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/21.
//

import SwiftUI

struct FeedFullCommentSheet: View {
    // MARK: Properties
    enum FocusField: Hashable {
        case comment
    }
    
    @FocusState private var focusedField: FocusField?
    @State private var commentText = ""
    let isEditing: Bool
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            if isEditing {
                Image("homeIndicator")
            }
            
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<5) { _ in
                            FeedCommentCell()
                            Divider()
                        }
                    }
                    .padding(.horizontal, GridLayout.side)
                }
                
                Spacer()
                
                // 댓글 TF
                HStack(alignment: .center, spacing: 16) {
                    // user profile image
                    Image("profile")
                        .resizable()
                        .frame(width: ComponentSizeType.XS.ProfileImageSize, height: ComponentSizeType.XS.ProfileImageSize)
                    
                    TextField("댓글을 입력해주세요", text: $commentText)
                        .focused($focusedField, equals: .comment)
                    
                    Spacer()
                    
                    Image("smallGreyButton-send")
                        .renderingMode(.template)
                        .foregroundColor(Color.odya.label.assistive)
                        .frame(width: 24, height: 24)
                }
                .frame(height: 48)
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(Color.odya.elevation.elev5)
                .cornerRadius(Radius.medium)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, GridLayout.side)
            .onAppear {
                if isEditing {
                    self.focusedField = .comment
                }
        }
        }
    }
}

// MARK: - Preview
struct FeedFullCommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        FeedFullCommentSheet(isEditing: false)
    }
}
