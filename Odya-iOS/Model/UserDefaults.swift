//
//  UserDefaults.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/06/04.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
  private let key: String
  private let defaultValue: T

  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}

/// 기본타입이 아닌 값(ex. Struct)을 UserDefaults에 data로 저장한뒤 로드, 저장시마다 인코딩, 디코딩 수행
@propertyWrapper
struct CodableUserDefault<T: Codable> {
  private let key: String
  private let defaultValue: T?

  init(key: String, defaultValue: T?) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T? {
    get {
      if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
        let decoder = JSONDecoder()
        if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
          return lodedObejct
        }
      }
      return defaultValue
    }
    set {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(newValue) {
        UserDefaults.standard.setValue(encoded, forKey: key)
      }
    }
  }
}

