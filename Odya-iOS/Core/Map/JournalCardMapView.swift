//
//  JournalCardMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/01.
//

import SwiftUI
import GoogleMaps

struct JournalCardMapView: UIViewRepresentable {
  // MARK: - Properties
  let size: SparkleMapMarker
  @Binding var dailyJournals: [DailyJournal]
  
  let mapView = GMSMapView()
  let maxMarkerCount: Int = 5
  
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
    let latitudes = dailyJournals.map { $0.latitudes }.joined().compactMap { $0 }
    let longitudes = dailyJournals.map { $0.longitudes }.joined().compactMap { $0 }
    var coordinates = [CLLocationCoordinate2D]()
    
    for i in 0..<min(latitudes.count, longitudes.count) {
        let latitude = latitudes[i]
        let longitude = longitudes[i]
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        coordinates.append(coordinate)
    }
    
    let imageUrls = dailyJournals.map { $0.images }.joined().compactMap { $0.imageUrl }
    
    uiView.clear()
    
    if coordinates.isEmpty {
      // 사진 좌표가 없을 때, placeId의 좌표로 카메라 이동
      let firstPlaceId = dailyJournals.map { $0.placeId }.first ?? ""
      if let placeId = firstPlaceId {
        placeId.placeIdToCoordinate { coordinate in
          let camera = GMSCameraPosition(target: coordinate, zoom: 15)
          DispatchQueue.main.async {
            uiView.camera = camera
          }
        }
        return
      } else {
        uiView.mapType = .none
        return
      }
    }
    
    uiView.mapType = .normal
    
    var bounds = GMSCoordinateBounds()
    let path = GMSMutablePath()
    var index = 0
    let markerCount = min(coordinates.count, imageUrls.count)
    let interval: Int = markerCount / maxMarkerCount
    
    for i in 0..<markerCount {
      if i == index {
        let marker = GMSMarker(position: coordinates[i])
        marker.iconView = CustomMarkerIconView(frame: .zero, urlString: imageUrls[i], sparkle: size)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
        marker.map = uiView
        index += interval
      }
      
      path.add(coordinates[i])
      bounds = bounds.includingCoordinate(coordinates[i])
    }
        
    let polyline = GMSPolyline(path: path)
    polyline.strokeColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1)
    polyline.strokeWidth = 1.31343
    polyline.map = uiView
    
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
