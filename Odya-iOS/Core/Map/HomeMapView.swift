//
//  HomeMapView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/20.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils

struct HomeMapView: UIViewRepresentable {
  // MARK: - Properties
  @EnvironmentObject var viewModel: HomeViewModel
  
  let mapView = GMSMapView()
  let locationManager = LocationManager.shared
  
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
    context.coordinator.clusterManager.clearItems()
    var coordinates = [CLLocationCoordinate2D]()
    
    if viewModel.selectedImageUserType == .user {
      viewModel.images.filter {
        $0.imageUserType == .user
      }.forEach {
        let marker = $0.marker
        marker.position.variateForEqual(coordinates: coordinates)
        coordinates.append(marker.position)
        context.coordinator.clusterManager.add(marker)
      }
    } else {
      viewModel.images.forEach {
        let marker = $0.marker
        marker.position.variateForEqual(coordinates: coordinates)
        coordinates.append(marker.position)
        context.coordinator.clusterManager.add(marker)
      }
    }
    context.coordinator.clusterManager.cluster()
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

// MARK: - MapViewCoordinator

extension HomeMapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate, GMUClusterRendererDelegate {
    var parent: HomeMapView
    var clusterManager: GMUClusterManager!
    
    init(_ parent: HomeMapView) {
      self.parent = parent
      super.init()
      setupClusterManager()
    }
    
    func setupClusterManager() {
      let iconGenerator = GMUDefaultClusterIconGenerator(buckets: [10000], backgroundColors: [UIColor(named: "base-yellow-50")!])
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
        mapView.animate(toZoom: mapView.camera.zoom + 1)
        print("Did tap cluster")
        return true
      }
      
      print("Did tap a normal marker")
      return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      let visibleRegion = parent.mapView.projection.visibleRegion()
      let northEast = visibleRegion.farRight
      let southWest = visibleRegion.nearLeft
      
      parent.viewModel.fetchCoordinateImages(
        leftLong: southWest.longitude,
        bottomLat: southWest.latitude,
        rightLong: northEast.longitude,
        topLat: northEast.latitude)
    }
  }
}
