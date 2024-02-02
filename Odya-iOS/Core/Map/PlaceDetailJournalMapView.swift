//
//  PlaceDetailJournalMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/01.
//

import SwiftUI
import GoogleMaps

struct PlaceDetailJournalMapView: UIViewRepresentable {
  // MARK: - Properties
  let placeId: String
  @Binding var coordinates: [CLLocationCoordinate2D]
  
  let mapView = GMSMapView()
  
  private let markerImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sparkle-filled-s"))
    imageView.layer.shadowColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1).cgColor
    imageView.layer.shadowRadius = 9
    imageView.layer.shadowOpacity = 0.8
    return imageView
  }()
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    setupMapStyle()

    mapView.isUserInteractionEnabled = false
    mapView.isMyLocationEnabled = false
    mapView.settings.myLocationButton = false
    mapView.settings.compassButton = false
    
    return mapView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.clear()
    
    if coordinates.isEmpty {
      // 사진 좌표가 없을 때, placeId의 좌표로 카메라 이동
      placeId.placeIdToCoordinate { coordinate in
        let camera = GMSCameraPosition(target: coordinate, zoom: 15)
        DispatchQueue.main.async {
          uiView.camera = camera
        }
      }
      return
    }
    
    var bounds = GMSCoordinateBounds()
    
    coordinates.forEach { coordinate in
      let marker = GMSMarker(position: coordinate)
      marker.iconView = markerImage
      marker.map = uiView
      bounds = bounds.includingCoordinate(coordinate)
    }
    
    let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      uiView.animate(with: update)
    })
  }
  
  func setupMapStyle() {
    if let styleURL = Bundle.main.url(forResource: "TemporaryDarkMapStyle", withExtension: "json") {
      mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
    }
  }
}
