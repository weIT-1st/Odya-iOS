//
//  ImageGridView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/18.
//

import Foundation
import SwiftUI

struct ImageGridView: View {
    var columns: [GridItem]
    var images: [UIImage]
    var imageSize: CGFloat
    var spacing: CGFloat
    
    init(images: [UIImage], totalWidth: CGFloat, spacing: CGFloat = 0, count: Int = 3) {
        self.images = images
        self.spacing = spacing
        let imageSize = (totalWidth - ((CGFloat(count) - 1) * spacing)) / CGFloat(count)
        self.imageSize = imageSize
        self.columns = Array(repeating: .init(.fixed(imageSize), spacing: spacing), count: count)
    }

    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(images, id: \.self) { anImage in
                    Image(uiImage: anImage)
                        .resizable()
                        .frame(height: imageSize)
                        .scaledToFit()
                        
                }
            }
        }
        
    }
}
