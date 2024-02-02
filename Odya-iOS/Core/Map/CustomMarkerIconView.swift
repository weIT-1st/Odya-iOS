//
//  CustomMarkerIconView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/30.
//

import UIKit
import Kingfisher
import SwiftUI

/// 지도 마커 아이콘 뷰 커스텀 (장소 사진 + 별)
class CustomMarkerIconView: UIView {
  // MARK: Properties
  let urlString: String
  
  private var placeImageView: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let starImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sparkle-filled-s"))
    imageView.layer.shadowColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1).cgColor
    imageView.layer.shadowRadius = 9
    imageView.layer.shadowOpacity = 0.8
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [placeImageView, starImageView])
    stack.axis = .vertical
    stack.spacing = -10
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  // MARK: Init
  init(frame: CGRect, urlString: String) {
    self.urlString = urlString
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Configure
  func configure() {
    let processor = ResizingImageProcessor(
      referenceSize: CGSize(width: placeImageView.frame.size.width,
                            height: placeImageView.frame.size.height))
    |> RoundCornerImageProcessor(cornerRadius: Radius.medium)
    
    placeImageView.kf.setImage(
      with: URL(string: urlString),
      options: [.processor(processor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}
