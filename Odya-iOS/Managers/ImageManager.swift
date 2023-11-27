//
//  ImageManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/01.
//

import UIKit
import SwiftUI
import webp

func getElapsedTime(start: Date) -> TimeInterval {
    let end = Date()
    let elapsedTime = end.timeIntervalSince(start)
    return elapsedTime
}
var totalByte: Int = 0

class WebPImageManager: ObservableObject {
    
    // MARK: PROPERTIES
    
    /// 변환한 webp 이미지들
    var webpImages: [(data: Data, imageName: String)] = []
    
    /// 변환 진행 상태
    @Published var isLoading = true
    

    // MARK: FUNCTIONS
    /// 하나의 uiImage를 webp로 변환
    /// uiImage가 없거나 변환에 실패했을 경우 nil 리턴
    func convertImageToWebPAsync(image: UIImage) async -> Data? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                if let webPData: Data = try? WebPEncoder().encode(image, config: .preset(.picture, quality: 85)) {
                    continuation.resume(returning: webPData)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    /// 여러 개의 uiImage를 알맞은 사이즈로 리사이징 후 webp로 변환
    /// 각 이미지에 대해 비동기 병렬로 작업 수행
    func processImages(images: [ImageData]) async -> [(Data, String)]{
        DispatchQueue.main.async {
            self.webpImages = []
            self.isLoading = true
        }

        // test !!!
        // let startDate = Date()

        // 현재 webpImageData는 항상 []로 초기화되어 있음
        // 변환시킬 이미지 개수만큼 webPImageData 배열 초기화
//        webPImageData = Array(repeating: WebPImgData(nil), count: imgList.count)

        // webP로 변환
        await withTaskGroup(of: Void.self) { group in
            // Add each image conversion task to the group
            for imageData in images {
                group.addTask {
                    // if let uiImage = imageData,
                  if let resizedImage = imageData.image.resizeAsync(maxSize: 1024){
                    if let webPData = await self.convertImageToWebPAsync(image: resizedImage) {
                      Task {
                        self.webpImages.append((data:webPData, imageName: imageData.imageName + ".webp"))
                        // test !!!
                        // totalByte += webPData.count

                      }
                    }else {
                      print("webp error")
                      
                    }
                  } else {
                      print("resizing error")
                    }
                }
            }

            await group.waitForAll()
        }

        DispatchQueue.main.async {
            self.isLoading = false
        }

        // print("\(webpImages.count) images converted to WebP: \(totalByte) bytes")
        // print("Time: \(getElapsedTime(start: startDate)) 초")
        return webpImages
    }
}


