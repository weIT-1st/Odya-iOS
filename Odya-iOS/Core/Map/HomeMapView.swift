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
  private var clusterManager: GMUClusterManager!
  
  // MARK: - Init
  
  init() {
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
    clusterManager.cluster()
  }
  
  // MARK: - View
  
  func makeUIView(context: Context) -> some GMSMapView {
    setupMyLocationButton()
    setupMapStyle()
    
    mapView.delegate = context.coordinator
    clusterManager.setMapDelegate(context.coordinator)
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
        clusterManager.add($0.marker)
      }
    } else {
      viewModel.images.forEach {
        $0.marker.map = uiView
        clusterManager.add($0.marker)
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

// MARK: - MapViewCoordinator

extension HomeMapView {
  class MapViewCoordinator: NSObject, GMSMapViewDelegate, GMUClusterRendererDelegate {
    var parent: HomeMapView
    
    init(_ parent: HomeMapView) {
      self.parent = parent
    }
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      // center the map on tapped marker
      mapView.animate(toLocation: marker.position)
      // check if a cluster icon was tapped
      if marker.userData is GMUCluster {
        // zoom in on tapped cluster
        mapView.animate(toZoom: 30)
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
      
      print("Home Map - idleAt: \(northEast) ~ \(southWest)")
      parent.viewModel.fetchCoordinateImages(
        leftLong: southWest.longitude,
        bottomLat: southWest.latitude,
        rightLong: northEast.longitude,
        topLat: northEast.latitude)
    }
    
    // MARK: GMUClusterRendererDelegate
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
      print(#function)
      switch object {
      case let item as GMSMarker:
        return item
      case let cluster as GMUCluster:
        let count = cluster.count
        print("Cluster count: \(count)")
        let marker = GMSMarker()
        let label = UILabel()
        guard let firstItem = cluster.items.first as? GMSMarker else { return marker }
        label.text = "\(count)"
        label.textColor = .blue
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        marker.iconView = label
        marker.position = firstItem.position
        return marker
      default:
        return nil
      }
    }
  }
}
