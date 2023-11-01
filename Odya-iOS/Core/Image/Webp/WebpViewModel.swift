//
//  WebpViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/17.
//

import UIKit
import SwiftUI
import webp
import Combine

// test용!!!!-------------------------------------------------------//
var totalByte: Int = 0
var resizingTimeSum : TimeInterval = 0
var encodingTimeSum : TimeInterval = 0

func getElapsedTime(start: Date) -> TimeInterval {
    let end = Date()
    let elapsedTime = end.timeIntervalSince(start)
    return elapsedTime
}
//----------------------------------------------------------------//


class WebpViewModel: ObservableObject {
    
    // MARK: PROPERTIES
    
    /// 변환한 webp 이미지들
    var webpImages: [Data] = []
    
    /// 변환 진행 상태
    @Published var isLoading = true
    

    // MARK: FUNCTIONS
    
    enum WebPError: Error {
        case conversionFailed
    }
    
    func processImages(images: [UIImage]) -> AnyPublisher<[Data], Error> {
        let startTime = DispatchTime.now() // 시작 시간 측정
        self.isLoading = true
        
        return Publishers.MergeMany(images.map { uiImage in
            return Future { promise in
                if let resizedImage = uiImage.resizeAsync(maxSize: 1024),
                   let webPImage = try? WebPEncoder().encode(resizedImage, config: .preset(.picture, quality: 90)) {
                    promise(.success(webPImage))
                } else {
                    promise(.failure(WebPError.conversionFailed))
                }
            }
        })
        .collect()
        .map { result in
            let endTime = DispatchTime.now() // 작업 완료 시간 측정
            let elapsedTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000 // 초 단위로 변환
            print("Total time: \(elapsedTime) seconds") // 작업에 소요된 시간 출력
            self.isLoading = false
            return result   
        }
        .eraseToAnyPublisher()
    }
    
//    /// 여러 개의 uiImage를 알맞은 사이즈로 리사이징 후 webp로 변환, 변환한 webp 이미지를 서버로 전달
//    /// 각 이미지에 대해 비동기 병렬로 작업 수행
//    func processImages(uiImages: [UIImage]) async {
//        // start processing
//        DispatchQueue.main.async {
//            self.isLoading = true
//        }
//
//        // test !!!
//        let startDate = Date()
//
//        // webP로 변환
//        await withTaskGroup(of: Void.self) { group in
//            for uiImage in uiImages {
//                group.addTask {
//                    if let resizedImage = uiImage.resizeAsync(maxSize: 1024),
//                       let webPImage = await self.convertAnImageToWebPAsync(image: resizedImage) {
//                        Task {
//                            self.webpImages.append(webPImage)
//                            // test !!!
//                            totalByte += webPImage.count
//                            //await self.uploadImageToServer(image: webPImage) // 이미지를 변환한 후 바로 서버로 업로드
//                        }
//                    }
//                }
//            }
//
//            await group.waitForAll()
//        }
//
//        // finish processing
//        DispatchQueue.main.async {
//            self.isLoading = false
//        }
//
//        print("\(webpImages.count) images converted to WebP")
//        print("Bytes: \(totalByte) bytes, Time: \(getElapsedTime(start: startDate)) 초")
//
//        webpImages = []
//
//    }
//
//    /// 하나의 uiImage를 webp로 변환
//    /// uiImage가 없거나 변환에 실패했을 경우 nil 리턴
//    private func convertAnImageToWebPAsync(image: UIImage) async -> Data? {
//        return await withCheckedContinuation { continuation in
//            DispatchQueue.global().async {
//                if let webPData: Data = try? WebPEncoder().encode(image, config: .preset(.picture, quality: 90)) {
//                    continuation.resume(returning: webPData)
//                } else {
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }

    /*/ not yet
    private func uploadImageToServer(image: Data) {
        guard let imageData = webPImageData else {
            print("변환된 이미지가 없습니다.")
            return
        }
        
        let byteArray = [UInt8](image)
        // imageData를 서버로 업로드하는 로직을 추가
        // Alamofire 라이브러리를 사용하여 업로드
    }
    */
}

