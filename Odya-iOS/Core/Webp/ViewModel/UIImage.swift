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
        let scaleFactor = max(maxSize / self.size.width, maxSize / self.size.height)
        
        if scaleFactor >= 1.0 {
            return self
        }
        
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
        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        
        guard let scaledImage = context.makeImage() else {
            return nil
        }
        
        let resizedImage = UIImage(cgImage: scaledImage)
        return resizedImage
    }
}
