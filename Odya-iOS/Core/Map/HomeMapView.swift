//
//  HomeMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/20.
//

import SwiftUI
import GoogleMaps

struct HomeMapView: UIViewRepresentable {
  // MARK: - Properties
  @EnvironmentObject var viewModel: HomeViewModel
  
  let mapView = GMSMapView()
  let locationManager = LocationManager.shared
  
  private let markerImage: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "sparkle-filled"))
    imageView.layer.shadowColor = UIColor(red: 1, green: 0.83, blue: 0.12, alpha: 1).cgColor
    imageView.layer.shadowRadius = 9
    imageView.layer.shadowOpacity = 0.8
    return imageView
  }()
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    setupMyLocationButton()
    setupMapStyle()

    mapView.delegate = context.coordinator
    mapView.isUserInteractionEnabled = true
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = false
    mapView.settings.compassButton = true
    
    // 유저의 현재 위치 가져오기, Camera 위치 설정
    let location = locationManager.fetchCurrentLocation()
    let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
    mapView.camera = camera
    
    return mapView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    uiView.clear()
    
    if viewModel.selectedImageUserType == .user {
      viewModel.images.filter {
        $0.imageUserType == .user
      }.forEach {
        $0.marker.map = uiView
      }
    } else {
      viewModel.images.forEach {
        $0.marker.map = uiView
      }
    }
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
  
  func setupMapStyle() {
    if let styleURL = Bundle.main.url(forResource: "TemporaryDarkMapStyle", withExtension: "json") {
      mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
    }
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

// MARK: - GMSMapViewDelegate

extension HomeMapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate {
    var parent: HomeMapView
        
    init(_ parent: HomeMapView) {
      self.parent = parent
    }
        
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      let visibleRegion = parent.mapView.projection.visibleRegion()
      let northEast = visibleRegion.farRight
      let southWest = visibleRegion.nearLeft
      
      print("Home Map - idleAt: \(northEast) ~ \(southWest)")
      parent.viewModel.fetchCoordinateImages(
        leftLong: southWest.longitude,
        bottomLat: southWest.latitude,
        rightLong: northEast.longitude,
        topLat: northEast.latitude)
    }
  }
}

