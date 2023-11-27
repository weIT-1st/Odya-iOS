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
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
        } placeholder: {
            ProgressView()
                .frame(width: width, height: height)
        }
    }

}

