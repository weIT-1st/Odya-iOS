//
//  WebpTestView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/18.
//

import SwiftUI
import Foundation
import PhotosUI
import ImageIO
import Combine


struct WebpTestView : View {
    @State private var subscription = Set<AnyCancellable>()
    
    @State var images: Set<UIImage> = []
    @State private var showSheet = false
    
    @ObservedObject var webpVM = WebpViewModel()
    @State private var isProcessing = false
    @State private var webpImages: [Data] = []
    
    var body: some View {
        VStack {
            if images.isEmpty {
                Button("Select Images") {
                    showSheet.toggle()
                }
            } else {
                ImageGridView(images: Array(images), totalWidth: 300)
                
                if isProcessing == false {
                    Button(action: {
                        isProcessing = true
                        webpVM.processImages(images: Array(images))
                            .sink { completion in
                                switch completion {
                                case .finished:
                                    // 성공적으로 완료된 경우
                                    print("webp 변환 완료")
                                    break
                                case .failure(let error):
                                    // 에러가 발생한 경우
                                    print("Error: \(error)")
                                }
                            } receiveValue: { result in
                                // 이미지 변환 작업이 완료된 후 결과를 처리
                                webpImages = result
//                                for data in result {
//                                    // 결과를 사용하거나 처리
//                                }
                            }
                            .store(in: &subscription)
                        // Task { await webpVM.processImages(uiImages: Array(images)) }
                        
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
            CustomPhotoPickerView(imageList: $images)
        }
        
        
    }
}

struct CustomPhotoPickerView: UIViewControllerRepresentable {
    
    @Binding var imageList: Set<UIImage>
    var totalByte = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1000
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> CustomPhotoPickerView.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private var parent: CustomPhotoPickerView
        private var group = DispatchGroup() // DispatchGroup 추가
        
        init(_ parent: CustomPhotoPickerView) {
            self.parent = parent
        }
        
        // 원본 사진 바이트 수 체크
        private func getByteSize(image: UIImage) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let originalSize = imageData.count
                self.parent.totalByte += originalSize
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            for imageResult in results {
                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter() // DispatchGroup에 진입
                    imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let image = selectedImage as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.imageList.insert(image)
                                self.getByteSize(image: image)
                            }
                        }
                        self.group.leave() // 이미지 로드 완료를 알림
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("\(self.parent.imageList.count) images loaded: \(self.parent.totalByte) bytes")
            }
        }
    }

}




struct WebpTestView_Previes : PreviewProvider {
    static var previews : some View {
        WebpTestView()
    }
}
