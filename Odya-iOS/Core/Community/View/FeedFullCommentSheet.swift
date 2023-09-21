//
//  FeedFullCommentSheet.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/21.
//

import SwiftUI

struct FeedFullCommentSheet: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<5) { _ in
                    FeedCommentCell()
                    Divider()
                }
            }
            .padding(.horizontal, GridLayout.side)
        }
    }
}

struct FeedFullCommentSheet_Previews: PreviewProvider {
    static var previews: some View {
        FeedFullCommentSheet()
    }
}
