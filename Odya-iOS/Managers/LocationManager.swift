//
//  LocationManager.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/20.
//

import Foundation
import SwiftUI
import CoreLocation

/**
 위치 정보를 가져오는 Location Manager
 */
final class LocationManager: NSObject, ObservableObject {
  // MARK: - Properties
  
  private let locationManager = CLLocationManager()
  static let shared = LocationManager()
  
  // MARK: - Life cycle
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization() // 권한 요청
    locationManager.allowsBackgroundLocationUpdates = true  // 백그라운드 위치 수집
    locationManager.startUpdatingLocation() // 위치 업데이트 시작
  }
  
  // MARK: - Helpers
  
  func fetchCurrentLocation() -> CLLocation {
    return locationManager.location ?? CLLocation(latitude: 37.566508, longitude: 126.977945)
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  
  // 위치가 변경되었을 때 호출
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !locations.isEmpty else { return }
    
    // 백그라운드에서도 초단위로 계속 업데이트해서 위치 받으면 일단 멈춤
    locationManager.stopUpdatingLocation()
    
    // TODO: - 백그라운드에서 5분 간격으로 위치 좌표 수집하도록 변경
  }
  
  // 위치 권한 상태가 변경되었을 때 호출
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
      // 항상 허용
    case .authorizedAlways:
      manager.startUpdatingLocation()
      // 앱 사용 시 허용
    case .authorizedWhenInUse:
      manager.startUpdatingLocation()
      // 권한 거부 및 권한 대기
    case .denied,
        .notDetermined,
        .restricted:
      // 권한 요청 팝업창
      manager.requestAlwaysAuthorization()
    @unknown default:
      break
    }
  }
}
