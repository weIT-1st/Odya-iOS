//
//  UserDefaultsData.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2/19/24.
//

import Foundation

/// 내 정보
struct MyData {
  @UserDefault(key: keyEnum_MyData.userId.rawValue, defaultValue: -1)
  static var userID: Int  // 다른곳에서 공유해 읽기위해 static으로 변경했습니다

  @UserDefault(key: keyEnum_MyData.nickname.rawValue, defaultValue: "")
  static var nickname: String

  @UserDefault(key: keyEnum_MyData.profile.rawValue, defaultValue: "")
  static var profile: String
}

/// 애플 유저 데이터 저장
struct AppleUserData {
  @UserDefault(key: keyEnum_APPLE_USER.isValid.rawValue, defaultValue: false)
  static var isValid: Bool

  @UserDefault(key: keyEnum_APPLE_USER.userIdentifier.rawValue, defaultValue: "")
  static var userIdentifier: String

  @UserDefault(key: keyEnum_APPLE_USER.familyName.rawValue, defaultValue: "")
  static var familyName: String

  @UserDefault(key: keyEnum_APPLE_USER.givenName.rawValue, defaultValue: "")
  static var givenName: String

  @UserDefault(key: keyEnum_APPLE_USER.email.rawValue, defaultValue: "")
  static var email: String
}

/// 최근 검색어 저장
struct SearchData {
  @UserDefault(key: keyEnum_Search.recentSearchText.rawValue, defaultValue: [String]())
  static var recentSearchText: [String]
}

/// 최근 검색된 유저 저장
struct SearchUserData {
  @CodableUserDefault(key: keyEnum_Search.recentSearchUser.rawValue, defaultValue: nil)
  static var recentSearchUser: [SearchedUserContent]?
}

/// 여행일지 임시저장
struct TempTravelJournalData {
  @UserDefault(key: keyEnum_TempTravelJournal.temporaryJournalExists.rawValue, defaultValue: false)
  var dataExist: Bool
  
  @UserDefault(key: keyEnum_TempTravelJournal.journalId.rawValue, defaultValue: -1)
  var journalId: Int

  @UserDefault(key: keyEnum_TempTravelJournal.title.rawValue, defaultValue: "")
  var title: String

  @UserDefault(key: keyEnum_TempTravelJournal.startDate.rawValue, defaultValue: Date())
  var startDate: Date
  
  @UserDefault(key: keyEnum_TempTravelJournal.endDate.rawValue, defaultValue: Date())
  var endDate: Date
  
  @UserDefault(key: keyEnum_TempTravelJournal.mates.rawValue, defaultValue: [String]())
  var mates: [String]
  
  @UserDefault(key: keyEnum_TempTravelJournal.privacyType.rawValue, defaultValue: "")
  var privacyType
  
  @UserDefault(key: keyEnum_TempTravelJournal.dailyJournals.rawValue, defaultValue: [String]())
  var dailyJournals: [String]
}

/// 알림 설정
//struct NotiSetting {
//  @UserDefault(key: keyEnum_NotiSetting.all.rawValue, defaultValue: true)
//  static var allEnabled: Bool
//
//  @UserDefault(key: keyEnum_NotiSetting.feedOdya.rawValue, defaultValue: true)
//  static var feetOdyaEnabled: Bool
//
//  @UserDefault(key: keyEnum_NotiSetting.feedComment.rawValue, defaultValue: true)
//  static var feetCommentEnabled: Bool
//
//  @UserDefault(key: keyEnum_NotiSetting.marketing.rawValue, defaultValue: true)
//  static var marketingEnabled: Bool
//}

enum keyEnum_MyData: String {
  case userId
  case nickname
  case profile
}

enum keyEnum_APPLE_USER: String {
  case isValid
  case userIdentifier
  case familyName
  case givenName
  case email
}

enum keyEnum_Search: String {
  case recentSearchText
  case recentSearchUser
}

enum keyEnum_TempTravelJournal: String {
  case temporaryJournalExists
  case journalId
  case title
  case startDate
  case endDate
  case mates
  case privacyType
  case dailyJournals
}


//enum keyEnum_NotiSetting: String {
//  case all
//  case feedOdya
//  case feedComment
//  case marketing
//}
