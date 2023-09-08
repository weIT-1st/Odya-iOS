//
//  ImageGridView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/18.
//

import Foundation
import SwiftUI

struct ImageGridView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var images: [UIImage]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(images, id: \.self) { anImage in
                    Image(uiImage: anImage)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}
