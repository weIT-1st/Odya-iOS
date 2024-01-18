//
//  PlaceTagMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2024/01/17.
//

import SwiftUI
import GoogleMaps

struct PlaceTagMapView: UIViewRepresentable {
  // MARK: - Properties
  
  @Binding var markers: [GMSMarker]
  @Binding var selectedMarker: GMSMarker?
  @Binding var bounds: GMSCoordinateBounds
  
  let mapView = GMSMapView()
  let locationManager = LocationManager.shared
  
  private let markerImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sparkle-filled"))
    imageView.layer.shadowColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1).cgColor
    imageView.layer.shadowRadius = 9
    imageView.layer.shadowOpacity = 0.8
    return imageView
  }()
  
  private let selectedMarkerImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sparkle-selected"))
    imageView.layer.shadowColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1).cgColor
    imageView.layer.shadowRadius = 9
    imageView.layer.shadowOpacity = 0.8
    return imageView
  }()
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    mapView.delegate = context.coordinator
    mapView.isUserInteractionEnabled = true
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = false
    mapView.settings.compassButton = true
    
    // 유저의 현재 위치 가져오기, Camera 위치 설정
    let location = locationManager.fetchCurrentLocation()
    let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
    mapView.camera = camera
    
    // style
    if let styleURL = Bundle.main.url(forResource: "TemporaryDarkMapStyle", withExtension: "json") {
      mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
    }
    
    return mapView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.clear()
    
    markers.forEach { marker in
      marker.iconView = markerImage
      marker.map = uiView
    }
    
    selectedMarker?.iconView = selectedMarkerImage
    selectedMarker?.zIndex = 1
    selectedMarker?.map = uiView
    
    if uiView.selectedMarker != selectedMarker {
      uiView.selectedMarker = selectedMarker
    }
    
    if !markers.isEmpty {
      let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        uiView.animate(with: update)
      })
    }
  }
  
  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator(self)
  }
}

extension PlaceTagMapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate {
    // MARK: - Properties
    
    var parent: PlaceTagMapView
    
    // MARK: - Life cycle
    
    init(_ parent: PlaceTagMapView) {
      self.parent = parent
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      
    }
  }
}
