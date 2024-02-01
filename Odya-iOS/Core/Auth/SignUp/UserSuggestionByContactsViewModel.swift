//
//  UserSuggestionByContactsViewModel.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 1/27/24.
//

import SwiftUI
import Moya
import Combine
import CombineMoya
import Contacts

struct Contact {
  var id: String
  var phoneNumber: String
}

enum ContactsError: Error {
  case accessDenied
}

class UserSuggestionByContactsViewModel: ObservableObject {
  
  // Moya
  @AppStorage("WeITAuthToken") var idToken: String?
  private let logPlugin: PluginType = NetworkLoggerPlugin(
    configuration: .init(logOptions: .verbose))
  private lazy var authPlugin = AccessTokenPlugin { [self] _ in idToken ?? "" }
  private lazy var userProvider = MoyaProvider<UserRouter>(
    session: Session(interceptor: AuthInterceptor.shared), plugins: [logPlugin, authPlugin])
  private var subscription = Set<AnyCancellable>()
  
  // data
  var contacts: [Contact] = []
  @Published var suggestedUsers: [FollowUserData] = []
  
  var contactIdx: Int = 0 // 유저 검색한 마지막 연락처 인덱스
  var newSuggestionCount: Int = 0 // 초기 및 스크롤 한 번으로 추가되는 추천 팔로우 수 최대 10
  
  var suggestMoreSubject = PassthroughSubject<(), Never>()
  
  var isLoading: Bool = false
  
  
  init() {
    getContacts() { result in
      self.contacts = result
      self.suggestUsers()
    }
    
    suggestMoreSubject.sink { [weak self] _ in
      guard let self = self else { return }
      if !self.isLoading {
        self.suggestUsers()
      }
    }.store(in: &subscription)
  }
  
  // MARK: search user by contacts
  
  func suggestUsers() {
    
    func fetchNextPage() {
      let lastIdx = min(self.contactIdx + 30, self.contacts.count - 1)
      let phoneNumbers: [String] = contacts[self.contactIdx + 1...lastIdx]
        .compactMap { self.getValidPhoneNumber(phoneNumber: $0.phoneNumber) }
      self.contactIdx = lastIdx
      searchUsersByContactsApi(phoneNumbers: phoneNumbers) {
        if self.newSuggestionCount >= 10 {
          return
        }
        if self.contactIdx >= self.contacts.count - 1 {
          return
        }
        fetchNextPage()
      }
    }
    
    newSuggestionCount = 0
    fetchNextPage()
  }
  
  private func searchUsersByContactsApi(phoneNumbers: [String],
                                        completion: @escaping () -> Void) {
    if isLoading || phoneNumbers.isEmpty {
      return
    }
    
    isLoading = true
    userProvider.requestPublisher(.searchUserByPhoneNumber(phoneNumbers: phoneNumbers))
      .sink { apiCompletion in
        switch apiCompletion {
        case .finished:
          self.isLoading = false
        case .failure(let error):
          self.isLoading = false
          self.processErrorResponse(error)
        }
        completion()
      } receiveValue: { response in
        guard let responseData = try? response.map([FollowUserData].self) else {
          return
        }
        self.suggestedUsers += responseData
        self.newSuggestionCount += responseData.count
      }.store(in: &subscription)
  }
  
  
  // MARK: get contacts from device
  private func getContacts(completion: @escaping ([Contact]) -> Void) {
    DispatchQueue.global().async {
      let store = CNContactStore()
      var contacts: [Contact] = []
      
      // 연락처에 요청할 항목
      let keys = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
      // Request 생성
      let request = CNContactFetchRequest(keysToFetch: keys)
      // 연락처 읽을 때 정렬해서 읽어오도록 설정
      request.sortOrder = CNContactSortOrder.userDefault
      
      // 권한체크
      store.requestAccess(for: .contacts) { granted, error in
        guard granted else {
          // 권한이 없을 때의 처리
          DispatchQueue.main.async {
            completion([])
          }
          return
        }
        do {
          // 연락처 데이터 획득
          try store.enumerateContacts(with: request) { contact, stop in
            guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else { return }
            let id = contact.identifier
            
            let contactToAdd = Contact(id: id, phoneNumber: phoneNumber)
            contacts.append(contactToAdd)
          }
          // 완료 후 메인 스레드에서 결과 전달
          DispatchQueue.main.async {
            completion(contacts)
          }
        } catch let error {
          print(error.localizedDescription)
          // 에러가 발생했을 때의 처리
          DispatchQueue.main.async {
            completion([])
          }
        }
      }
    }
  }
  
  // MARK: processing error response
  private func processErrorResponse(_ error: MoyaError) {
    if let errorData = try? error.response?.map(ErrorData.self) {
      print("ERROR: In Place Detail Bookmark with \(errorData.message)")
    } else {  // unknown error
      print("ERROR: \(error.localizedDescription)")
    }
  }
  
  // MARK: validate phonenumber

  func getValidPhoneNumber(phoneNumber: String) -> String? {
  
    func isValidWithoutHypen(_ number: String) -> Bool {
      
      let regex = "01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})"
      return NSPredicate(format: "SELF MATCHES %@", regex)
        .evaluate(with: number)
    }
    
    if phoneNumber.validatePhoneNumber() {
      return phoneNumber
    } else if isValidWithoutHypen(phoneNumber) {
      var phoneNumberWithHypen = phoneNumber
      phoneNumberWithHypen.insert("-", at: phoneNumberWithHypen.index(phoneNumberWithHypen.startIndex, offsetBy: 3))
      phoneNumberWithHypen.insert("-", at: phoneNumberWithHypen.index(phoneNumberWithHypen.endIndex, offsetBy: -4))
      return phoneNumberWithHypen
    } else  {
      return nil
    }
  }

}