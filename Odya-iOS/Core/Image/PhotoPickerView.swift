//
//  PhotoPickerView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/18.
//


import SwiftUI
import PhotosUI
import Photos

struct PhotoPickerView: UIViewControllerRepresentable {
  
  @Binding var imageList: [ImageData]
  var maxImageCount: Int = 15
  
  var accessStatus: PHAuthorizationStatus
  var totalByte = 0
  
  @Environment(\.presentationMode) var presentationMode
  
//  init(imageList: Binding<[ImageData]>, accessStatus: PHAuthorizationStatus) {
//    self._imageList = imageList
//    self.accessStatus = accessStatus
//  }
//  
//  init(image: Binding<[ImageData]>, maxImageCount: Int, accessStatus: PHAuthorizationStatus) {
//    self._imageList = image
//    self.maxImageCount = maxImageCount
//    self.accessStatus = accessStatus
//  }
//  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    let photoLibrary = PHPhotoLibrary.shared()
    
    var config = PHPickerConfiguration(photoLibrary: photoLibrary)
    config.filter = .any(of: [.images, .livePhotos, .panoramas, .screenshots, .bursts, .depthEffectPhotos])
    config.selectionLimit = maxImageCount
    
    if !imageList.isEmpty {
      config.preselectedAssetIdentifiers = imageList.map{ $0.assetIdentifier }
    }
    
    let controller = PHPickerViewController(configuration: config)
    controller.delegate = context.coordinator
    
    // 접근가능한 사진을 선택하는 창이 매번 뜨게 됩니다!!
    if accessStatus == .limited {
      photoLibrary.presentLimitedLibraryPicker(from: controller)
    }
    
    return controller
  }
  
  func makeCoordinator() -> PhotoPickerView.Coordinator {
    return Coordinator(self)
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
  
  
  class Coordinator: PHPickerViewControllerDelegate {
    
    private var parent: PhotoPickerView
    private var group = DispatchGroup()
    
    init(_ parent: PhotoPickerView) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.presentationMode.wrappedValue.dismiss()
      guard !results.isEmpty else {
        return
      }
      
      var newImageAssetIdentifiers: [String] = []
      var newImageList: [ImageData] = self.parent.imageList
      
      for imageResult in results {
        if let assetID = imageResult.assetIdentifier {
          newImageAssetIdentifiers.append(assetID)
        }
        
        if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
          group.enter() // DispatchGroup에 진입
          imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
            guard let image = selectedImage as? UIImage,
                  let assetID = imageResult.assetIdentifier else {
              if let error = error {
                print(error.localizedDescription)
              }
              return
            }
            
            DispatchQueue.main.async {
              let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
              let imageName = assetResults.firstObject?.localIdentifier ?? ""
              let imageCreationDate =  assetResults.firstObject?.creationDate
              let imageLocation = assetResults.firstObject?.location?.coordinate
              
              let newImageData = ImageData(assetIdentifier: assetID,
                                           image: image.resizeAsync(maxSize: 1024) ?? image,
                                           imageName: imageName,
                                           creationDate: imageCreationDate,
                                           location: imageLocation)
              newImageList.insert(newImageData, at: 0)
            }
            
            self.group.leave() // 이미지 로드 완료를 알림
          }
        }
      }
      
      group.notify(queue: .main) {
        self.parent.imageList = newImageList.filter{ newImageAssetIdentifiers.contains($0.assetIdentifier) }
      }
    }
    
  }
  
}

