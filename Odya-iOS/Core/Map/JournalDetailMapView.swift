//
//  JournalDetailMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/02/06.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct JournalDetailMapView: UIViewRepresentable {
  // MARK: - Properties
  let size: SparkleMapMarker
  @Binding var dailyJournals: [DailyJournal]
  
  let mapView = GMSMapView()
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    setupMapStyle()
    
    mapView.delegate = context.coordinator
    mapView.isUserInteractionEnabled = true
    mapView.isMyLocationEnabled = false
    mapView.settings.myLocationButton = false
    mapView.settings.compassButton = false
    
    return mapView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.clear()
    context.coordinator.clusterManager.clearItems()
    
    let latitudes = dailyJournals.map { $0.latitudes }.joined().compactMap { $0 }
    let longitudes = dailyJournals.map { $0.longitudes }.joined().compactMap { $0 }
    var coordinates = [CLLocationCoordinate2D]()
    let count = min(latitudes.count, longitudes.count)
    
    for i in 0..<count {
        let latitude = latitudes[i]
        let longitude = longitudes[i]
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        coordinates.append(coordinate)
    }
    
    let imageUrls = dailyJournals.map { $0.images }.joined().compactMap { $0.imageUrl }
    
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
        
    for i in 0..<min(coordinates.count, imageUrls.count) {
      let marker = GMSMarker(position: coordinates[i])
      marker.iconView = CustomMarkerIconView(frame: .zero, urlString: imageUrls[i], sparkle: size)
      marker.groundAnchor = CGPoint(x: 0.5, y: 0.75)
      context.coordinator.clusterManager.add(marker)
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
    
    context.coordinator.clusterManager.cluster()
  }
  
  func setupMapStyle() {
    if let styleURL = Bundle.main.url(forResource: "TemporaryDarkMapStyle", withExtension: "json") {
      mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
    }
  }
  
  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator(self)
  }
}

extension JournalDetailMapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate, GMUClusterRendererDelegate {
    var parent: JournalDetailMapView
    var clusterManager: GMUClusterManager!
    
    init(_ parent: JournalDetailMapView) {
      self.parent = parent
      super.init()
      setupClusterManager()
    }
    
    func setupClusterManager() {
      let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [50], backgroundColors: [UIColor(named: "base-yellow-50")!])
      let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
      let renderer = GMUDefaultClusterRenderer(mapView: parent.mapView, clusterIconGenerator: iconGenerator)
      renderer.delegate = self
      clusterManager = GMUClusterManager(map: parent.mapView, algorithm: algorithm, renderer: renderer)
      clusterManager.setMapDelegate(self)
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      if marker.userData is GMUCluster {
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: mapView.camera.zoom + 2)
        return true
      } else {
        return false
      }
    }
  }
}
