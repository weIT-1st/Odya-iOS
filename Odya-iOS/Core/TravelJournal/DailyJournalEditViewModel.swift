//
//  DailyJournalEditViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/08.
//

import ImageIO
import Photos
import PhotosUI
import SwiftUI

class DailyJournalEditViewModel: ObservableObject {
  @Published var selectedImages: [ImageData] = []
  @Published var showImagePickerSheet: Bool = false
  @Published var showImagesPermissionDeniedAlert: Bool = false

  func addImages() {
    self.requestPHPhotoLibraryAuthorization {
      //            self.fetchAccessibleImages()
    }
  }

  func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
      switch status {
      case .authorized, .limited:
        self.showImagePickerSheet = true
        completion()
      case .denied, .restricted:
        self.showImagesPermissionDeniedAlert = true
        break
      default:
        break
      }
    }
  }

}
