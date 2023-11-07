//
//  AsyncImageView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/03.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
//    init(url: String, width: CGFloat = 0, height: CGFloat = 0, cornerRadius: CGFloat = Radius.medium) {
//        self.url = url
//        self.width = width
//        self.height = height
//        self.cornerRadius = cornerRadius
//    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
//            if width != 0 {
//                if height != 0 {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .cornerRadius(cornerRadius)
//                } else {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: width)
//                        .cornerRadius(cornerRadius)
//                }
//            } else {
//                if height != 0 {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: height)
//                        .cornerRadius(cornerRadius)
//                } else {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .cornerRadius(cornerRadius)
//                }
//
//            }
            
        } placeholder: {
            ProgressView()
                .frame(width: width, height: height)
        }
    }

}

