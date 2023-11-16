//
//  UIImage.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/06/17.
//

import Foundation
import UIKit

extension UIImage {
    func resizeAsync(maxSize: CGFloat) -> UIImage? {
        if self.size.width <= 1024 && self.size.height <= 1024 {
            return self
        }
      
        let removedOrientationImage = removedOrientationImage(self)
      
        let scaleFactor = min(maxSize / self.size.width, maxSize / self.size.height)
        let scaledWidth = self.size.width * scaleFactor
        let scaledHeight = self.size.height * scaleFactor
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: Int(scaledWidth), height: Int(scaledHeight),
                                      bitsPerComponent: 8, bytesPerRow: 0,
                                      space: colorSpace, bitmapInfo: bitmapInfo)
        else { return nil }
        
        context.interpolationQuality = .high
        context.draw(removedOrientationImage.cgImage!, in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        
        guard let scaledImage = context.makeImage() else {
            return nil
        }
        
        let resizedImage = UIImage(cgImage: scaledImage)
        return resizedImage
    }
  
    /// 사진 방향 제거
    func removedOrientationImage(_ image: UIImage) -> UIImage {
        guard image.imageOrientation != .up else { return image } // up 방향일때 제외
      
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
      
        return normalizedImage ?? image
    }
}
