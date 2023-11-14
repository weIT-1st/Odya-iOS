//
//  ImagePicker.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/08.
//
//

import SwiftUI
import PhotosUI
//
//class ImagePicker: ObservableObject {
//
//    @Published var images: [PHAsset] = []
//
//    @Published var imageSelections: [PhotosPickerItem] = [] {
//        didSet {
//            Task {
//                if !imageSelections.isEmpty {
//                    try await loadTransferable(from: imageSelections)
//                    await clearImageSelections()
////                    imageSelections = []
//                }
//            }
//        }
//    }
//
//    func loadTransferable(from imageSelections: [PhotosPickerItem]) async throws {
//        print("ImagePicker - loadTransferable() called")
//        do {
//            for selectedImage in imageSelections {
////                if let data = try await selectedImage.loadTransferable(type: Data.self) {
////                    if let uiImage = UIImage(data: data),
//                if selectedImage.itemIdentifier != nil {
//                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [selectedImage.itemIdentifier!], options: nil)
//                    if let asset = result.firstObject {
//                        await self.appendImage(asset)
//                    }
//                }
//            }
//        }
////        catch {
////            print(error.localizedDescription)
////        }
//    }
//
//    @MainActor
//    func appendImage(_ asset: PHAsset) {
//        self.images.append(asset)
//    }
//
//    @MainActor
//    func clearImageSelections() {
//        self.imageSelections = []
//    }
//}


//import Foundation
//import SwiftUI
//import PhotosUI
//import ImageIO
//
//struct ImagePicker: UIViewController, UIViewControllerRepresentable {
//    
//    @Binding var imageList: [ImageData]
//    var accessStatus: PHAuthorizationStatus
//    var totalByte = 0
//    
//    var fetchResult: PHFetchResult<PHAsset>?
//    var canAccessImages: [UIImage] = []
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
////        getCanAccessImages()
//        print("--- makeUIViewController called ---")
//        
//        let photoLibrary = PHPhotoLibrary.shared()
//
//        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
//        config.filter = .any(of: [.images, .livePhotos, .panoramas, .screenshots, .bursts, .depthEffectPhotos])
//        config.selectionLimit = 15
//        if !imageList.isEmpty {
//            config.preselectedAssetIdentifiers = imageList.map{ $0.assetIdentifier }
//        }
//        
//        let controller = PHPickerViewController(configuration: config)
//        controller.delegate = context.coordinator
//        
////        if accessStatus == .limited {
////            photoLibrary.presentLimitedLibraryPicker(from: controller)
////        }
//        
//        return controller
//    }
//    
//    func makeCoordinator() -> PhotoPickerView.Coordinator {
//        print("--- makeCoordinator called ---")
//        return Coordinator(self)
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//        print("--- updateUIViewController called ---")
//    }
//    
//    class Coordinator: PHPickerViewControllerDelegate {
//        
//        private var parent: PhotoPickerView
//        private var group = DispatchGroup()
//        
//        init(_ parent: PhotoPickerView) {
//            self.parent = parent
//        }
//        
//        // 원본 사진 바이트 수 체크
//        private func getByteSize(image: UIImage) {
//            if let imageData = image.jpegData(compressionQuality: 1.0) {
//                let originalSize = imageData.count
//                self.parent.totalByte += originalSize
//            }
//        }
//        
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            print("--- picker called ---")
//            
//            parent.presentationMode.wrappedValue.dismiss()
//            guard !results.isEmpty else {
//                return
//            }
//            
//            var newImageAssetIdentifiers: [String] = []
//            var newImageList: [ImageData] = self.parent.imageList
//            
//            for imageResult in results {
//                if let assetID = imageResult.assetIdentifier {
//                    newImageAssetIdentifiers.append(assetID)
//                }
//                
//                if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    group.enter() // DispatchGroup에 진입
//                    imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
//                        guard let image = selectedImage as? UIImage,
//                              let assetID = imageResult.assetIdentifier else {
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                            return
//                        }
//                        
//                        DispatchQueue.main.async {
//                            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
//                            let imageCreationDate = assetResults.firstObject?.creationDate
//                            let imageLocation = assetResults.firstObject?.location?.coordinate
//                            
//                            let newImageData = ImageData(assetIdentifier: assetID,
//                                                         image: image,
//                                                         creationDate: imageCreationDate,
//                                                         location: imageLocation)
//                            
//                            debugPrint("new Image Data: \(newImageData)")
//                            
//                            newImageList.insert(newImageData, at: 0)
//                        }
//                        
//                        self.group.leave() // 이미지 로드 완료를 알림
//                    }
//                }
////                else {
////                    debugPrint("cannot be loaded: \(imageResult)")
////                }
//            }
//            
//            group.notify(queue: .main) {
//                self.parent.imageList = newImageList.filter{ newImageAssetIdentifiers.contains($0.assetIdentifier) }
//            }
//        }
//        
//    }
//
//}
//
//
//
