//
//  SettingView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/08.
//

import CoreLocation
import SwiftUI

// MARK: Setting Route
/// 환경설정 뷰에서 NavigationStack으로 이동할 뷰 타입
enum SettingRoute: Hashable {
  case userInfoEditView
  case privacyPolicyView
  case serviceTermsView
  case openSourceView
}

// MARK: Setting Row Cell
struct SettingRowCell<Content: View>: View {
  let hasDivider: Bool
  @ViewBuilder let content: Content

  var body: some View {
    VStack(spacing: 0) {
      content
        .frame(minHeight: 36)

      if hasDivider {
        divider.padding(.top, 12)
      }
    }
  }

  private var divider: some View {
    HStack(spacing: 0) {}
      .frame(maxWidth: .infinity)
      .frame(height: 1)
      .background(Color.odya.line.alternative)
  }
}

// MARK: Setting View
struct SettingView: View {
  //  @StateObject var termsVM = TermsViewModel()
  let locationManager = CLLocationManager()

  @State private var notiAllSetting = NotificationSetting(.all)
  @State private var notiDetailSettings: [NotificationSetting] = [
    NotificationSetting(.feedOdya),
    NotificationSetting(.feedComment),
    NotificationSetting(.marketing),
  ]
  
  var isLocationTrackingOn: Bool {
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      return true
    case .notDetermined, .restricted, .denied:
      return false
    @unknown default:
      return false
    }
  }

  var body: some View {
    VStack {
      CustomNavigationBar(title: "환경설정")

      ScrollView {
        VStack(spacing: 12) {
          // 회원정보 수정
          SettingRowCell(hasDivider: true) {
            linkButtonView(
              nextPageTitle: "회원정보 수정",
              destination: .userInfoEditView)
          }

          // 개인정보 보호 정책 보기
          SettingRowCell(hasDivider: true) {
            linkButtonView(
              nextPageTitle: "개인정보 보호정책",
              destination: .privacyPolicyView)
          }

          // 이용약관 보기
          SettingRowCell(hasDivider: true) {
            linkButtonView(
              nextPageTitle: "이용약관",
              destination: .serviceTermsView)
          }

          // 알람 설정
          SettingRowCell(hasDivider: true) {
            notiSettingView
          }

          // 오픈소스 보기
          SettingRowCell(hasDivider: true) {
            linkButtonView(
              nextPageTitle: "오픈소스",
              destination: .openSourceView)
          }

          // 위치정보 수집 설정
          SettingRowCell(hasDivider: true) {
            locationTrackingConsentView
          }

          // 버전 정보
          SettingRowCell(hasDivider: true) {
            HStack {
              settingRowTitle("버전 정보")
              Spacer()
              Text("1.0.0")
                .b2Style()
                .foregroundColor(.odya.label.assistive)
            }
          }

          // 문의하기
          SettingRowCell(hasDivider: false) {
            HStack {
              settingRowTitle("문의하기")
              Spacer()
            }
          }
        }.padding(GridLayout.side)
      }.background(Color.odya.elevation.elev2)
    }
    .background(Color.odya.background.normal)
  }  // body

  private func settingRowTitle(_ title: String) -> some View {
    Text(title)
      .b1Style()
      .foregroundColor(.odya.label.normal)
  }
}

// MARK: Link Button
extension SettingView {
  func linkButtonView(
    nextPageTitle: String,
    destination: SettingRoute
  ) -> some View {
    NavigationLink(destination: {
      switch destination {
      case .userInfoEditView:
        UserInfoEditView()
          .navigationBarHidden(true)
      case .privacyPolicyView:
        TextView(
          title: "개인정보 보호정책",
          content: "개인정보 보호정책 내용"
        )
        .navigationBarHidden(true)
      case .serviceTermsView:
        TextView(
          title: "이용약관",
          content: "이용약관 내용"
        )
        .navigationBarHidden(true)
      case .openSourceView:
        TextView(
          title: "오픈소스",
          content: "오픈소스 내용"
        )
        .navigationBarHidden(true)
      }
    }) {
      HStack {
        settingRowTitle(nextPageTitle)
        Spacer()
        Image("direction-right")
          .colorMultiply(.odya.label.assistive)
      }.frame(height: 36)
    }
  }
}

// MARK: Noti Setting View
extension SettingView {
  var notiSettingView: some View {
    VStack(alignment: .trailing, spacing: 16) {
      // 알림 파트 타이틀 및 전체 알람 설정 토글
      HStack {
        settingRowTitle("알림설정")
        Spacer()
        ZStack(alignment: .trailing) {
          NotiToggleButton(notiSetting: $notiAllSetting)
          Button(action : {
            // 전체 알람 설정값에 따라 디테일 설정값 자동으로 변경
            setAll(!notiAllSetting.isOn)
          }) {
            HStack {}
              .frame(width: 51, height: 31)
              .contentShape(Rectangle()) // hit testing 영역 제외 방지용
          }
        }
        .animation(.default, value: notiAllSetting.isOn)
        .onChange(of: notiAllSetting.isOn) { _ in
          notiAllSetting.setEnabled()
        }
      }
      
      // 디테일 알람 설정 토글
      ForEach(notiDetailSettings.indices, id: \.self) { index in
        NotiToggleButton(notiSetting: $notiDetailSettings[index])
        .onChange(of: notiDetailSettings[index].isOn) { newValue in
          notiDetailSettings[index].setEnabled()
          
          // 전체 알람이 켜져있는 상태에서 디테일 설정을 끄면 전체 알람 자동으로 Off
          if newValue == false && notiAllSetting.isOn {
            notiAllSetting.isOn = false
          }
          
          // 디테일 설정값이 모두 켜져있다면 전체 알람 자동으로 On
          if isAllOn() {
            notiAllSetting.isOn = true
          }
        }
      }
    }
  }
  
  /// 전체 알람 설정 변경 시 디테일 설정값도 같이 변경
  private func setAll(_ isEnabled: Bool) {
    notiAllSetting.isOn = isEnabled
    for index in notiDetailSettings.indices {
      withAnimation {
        notiDetailSettings[index].isOn = isEnabled
      }
    }
  }
  
  /// 디테일 설정값이 모두 켜져있는지 확인
  private func isAllOn() -> Bool {
    return notiDetailSettings.filter{ $0.isOn == false }.isEmpty
  }
}

// MARK: Location Tracking Consent View
extension SettingView {
  var locationTrackingConsentView: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        settingRowTitle("위치 정보 수집")
        Spacer()
        locationTrackingToggle
      }

      Text("해당 기능을 끄면 여행일지의 동선이 간략화됩니다.")
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
        .frame(height: 9)
    }
  }

  private var locationTrackingToggle: some View {
    ZStack(alignment: isLocationTrackingOn ? .trailing : .leading) {
      RoundedRectangle(cornerRadius: 50)
        .fill(isLocationTrackingOn ? Color.odya.brand.primary : Color.odya.system.inactive)
      Circle()
        .foregroundColor(.white)
        .dropBoxShadow()
        .padding(2)
    }
    .frame(width: 51, height: 31)
    .onTapGesture {
      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
      }
    }
    .animation(.default, value: isLocationTrackingOn)
  }
}

// MARK: Preview
struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
