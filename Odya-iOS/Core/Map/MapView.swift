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
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        
        // 유저의 현재 위치 가져오기, Camera 위치 설정
        let location = locationManager.fetchCurrentLocation()
        let camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        mapView.camera = camera
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
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

