//
//  WebpTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/18.
//

import SwiftUI

struct WebpTestView : View {
    
    @State var images: Set<UIImage> = []
    @State private var showSheet = false
    
    @ObservedObject var webpVM = WebpViewModel()
    @State private var isProcessing = false
    
    var body: some View {
        VStack {
            if images.isEmpty {
                Button("Select Images") {
                    showSheet.toggle()
                }
            } else {
                ImageGridView(images: Array(images))
                
                if isProcessing == false {
                    Button(action: {
                        isProcessing = true
                        Task { await webpVM.processImages(uiImages: Array(images)) }
                        
                    }, label: {
                        Text("convert to WebP")
                            .foregroundColor(.black)
                            .frame(width: 200)
                            .padding(10)
                            .background(.yellow)
                            .cornerRadius(15)
                    })
                } else {
                    if webpVM.isLoading {
                        ProgressView().padding()
                    } else {
                        Text("All images converted to webP").padding()
                    }
                }
            }
        }.sheet(isPresented: $showSheet) {
//            PhotoPickerView(imageList: $images)
        }
        
        
    }
}

struct WebpTestView_Previes : PreviewProvider {
    static var previews : some View {
        WebpTestView()
    }
}
