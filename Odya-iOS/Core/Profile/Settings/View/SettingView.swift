//
//  SettingView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/08.
//

import SwiftUI

// MARK: Setting Route
/// 프로필 뷰에서 NavigationStack으로 이동할 뷰 타입
enum SettingRoute: Hashable {
  case userInfoEditView
  case privacyPolicyView
  case serviceTermsView
  case openSourceView
}

// MARK: Notification Setting
struct NotificationSetting: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool = false
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
  
  @State private var isAllNotiOn: Bool = false
  @State private var notificationSettings: [NotificationSetting] = [
          NotificationSetting(title: "커뮤니티 좋아요 알람"),
          NotificationSetting(title: "커뮤니티 댓글 알람"),
          NotificationSetting(title: "마케팅 알람")
      ]
  @State private var isLocationTrackingOn: Bool = false

  var body: some View {
    VStack {
      CustomNavigationBar(title: "환경설정")
      
      ScrollView {
        VStack(spacing: 12) {
          SettingRowCell(hasDivider: true) {
            linkButtonView(nextPageTitle: "회원정보 수정",
                           destination: .userInfoEditView)
          }
          
          SettingRowCell(hasDivider: true) {
            linkButtonView(nextPageTitle: "개인정보 보호정책",
                           destination: .privacyPolicyView)
          }
          
          SettingRowCell(hasDivider: true) {
            linkButtonView(nextPageTitle: "이용약관",
                           destination: .serviceTermsView)
          }
          
          SettingRowCell(hasDivider: true) {
            notiSettingView
          }
          
          
          SettingRowCell(hasDivider: true) {
            linkButtonView(nextPageTitle: "오픈소스",
                           destination: .openSourceView)
          }
          
          SettingRowCell(hasDivider: true) {
            locationTrackingConsentView
          }
          
          SettingRowCell(hasDivider: true) {
            versionTextView
          }
          
          SettingRowCell(hasDivider: false) {
            HStack {
              settingRowTitle("문의하기")
              Spacer()
            }.frame(height: 36)
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
  
  private func linkButtonView(nextPageTitle: String,
                              destination: SettingRoute) -> some View {
    NavigationLink(destination: {
      switch destination {
      case .userInfoEditView:
        UserInfoEditView()
          .navigationBarHidden(true)
      case .privacyPolicyView:
        TextView(title: "개인정보 보호정책",
                 content: "개인정보 보호정책 내용")
        .navigationBarHidden(true)
      case .serviceTermsView:
        TextView(title: "이용약관",
                 content: "이용약관 내용")
        .navigationBarHidden(true)
      case .openSourceView:
        TextView(title: "오픈소스",
                 content: "오픈소스 내용")
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
    
    
//    Button(action: {
//      path.append(destination)
//    }) {
//      HStack {
//        settingRowTitle(nextPageTitle)
//        Spacer()
//        Image("direction-right")
//          .colorMultiply(.odya.label.assistive)
//      }
//    }.frame(height: 36)
//      .navigationDestination(for: SettingRoute.self) { nextView in
//        switch nextView {
//        case .userInfoEditView:
//          UserInfoEditView()
//            .navigationBarHidden(true)
//        case .privacyPolicyView:
//          TextView(title: "개인정보 보호정책",
//                   content: "개인정보 보호정책 내용")
//          .navigationBarHidden(true)
//        case .serviceTermsView:
//          TextView(title: "이용약관",
//                   content: "이용약관 내용")
//          .navigationBarHidden(true)
//        case .openSourceView:
//          TextView(title: "오픈소스",
//                   content: "오픈소스 내용")
//          .navigationBarHidden(true)
//        }
//      }
//  }

  private var notiSettingView: some View {
    VStack(alignment: .trailing, spacing: 16) {
      HStack {
        settingRowTitle("알림설정")
        Spacer()
        Toggle(isOn: $isAllNotiOn) {
          HStack {
            Spacer()
            Text("전체 알람")
              .b1Style()
              .foregroundColor(.odya.label.assistive)
              .padding(.trailing, 24)
          }.frame(height: 36)
        }.toggleStyle(CustomToggleStyle())
      }
      
      ForEach(notificationSettings.indices, id: \.self) { index in
        Toggle(isOn: $notificationSettings[index].isOn) {
          HStack {
            Spacer()
            Text(notificationSettings[index].title)
              .b2Style()
              .foregroundColor(.odya.label.assistive)
              .padding(.trailing, 24)
          }
          .frame(height: 36)
        }
        .toggleStyle(CustomToggleStyle())
      }
    }
  }

  private var locationTrackingConsentView: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        settingRowTitle("위치 정보 수집")
        Spacer()
        Toggle(isOn: $isLocationTrackingOn) {
          HStack {}.frame(width: 0, height: 36)
        }.toggleStyle(CustomToggleStyle())
      }

      Text("해당 기능을 끄면 여행일지의 동선이 간략화됩니다.")
        .detail2Style()
        .foregroundColor(.odya.label.assistive)
        .frame(height: 9)
    }
  }

  private var versionTextView: some View {
    HStack {
      settingRowTitle("버전 정보")
      Spacer()
      Text("1.0.0")
        .b2Style()
        .foregroundColor(.odya.label.assistive)
    }.frame(height: 36)
  }
}


// MARK: Preview
struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
