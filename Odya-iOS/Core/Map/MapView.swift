//
//  MapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/20.
//

import SwiftUI
import GoogleMaps

struct MapView: UIViewRepresentable {
  // MARK: - Properties
  
  let mapView = GMSMapView()
  let locationManager = LocationManager.shared
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    setupMyLocationButton()
    
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
    
  }
  
  func setupMyLocationButton() {
    let myLocationButton = UIButton(type: .custom, primaryAction: .init(handler: { _ in
      centerMyLocation()
    }))
    myLocationButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
    myLocationButton.layer.cornerRadius = myLocationButton.bounds.size.width / 2
    myLocationButton.clipsToBounds = true
    let imageView = UIImageView()
    imageView.image = UIImage(named: "gps")?.withRenderingMode(.alwaysTemplate)
    myLocationButton.setImage(imageView.image, for: .normal)
    myLocationButton.tintColor = UIColor(red: 255/255, green: 212/255, blue: 31/255, alpha: 1)
    myLocationButton.backgroundColor = UIColor(named: "base-gray-100")
    
    
    mapView.addSubview(myLocationButton)
    myLocationButton.translatesAutoresizingMaskIntoConstraints = false
    myLocationButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
    myLocationButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
    myLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -20).isActive = true
    myLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
  }
  
  func centerMyLocation() {
    let location = locationManager.fetchCurrentLocation()
    let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
    mapView.animate(to: camera)
  }
  
  func makeCoordinator() -> MapViewCoordinator {
    return MapViewCoordinator(self)
  }
}

extension MapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate {
    // MARK: - Properties
    
    var parent: MapView
    
    // MARK: - Life cycle
    
    init(_ parent: MapView) {
      self.parent = parent
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      
    }
    
  }
}

