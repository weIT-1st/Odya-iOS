//
//  UserInfoValidator.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/08.
//

import SwiftUI

enum UserInfoField: String, CaseIterable {
    case nickname
    case phoneNumber
    case email
    
    /// 유저 정보가 유효한 형식인지 검사
    func isValid(value: String) -> Bool {
        switch self {
        case .nickname:
            // 최소 2 ~ 최대 8자, 특수문자 불가능
            let nicknameRegex = "^[A-Za-z0-9가-힣]{2,8}$"
            let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
            return nicknamePredicate.evaluate(with: value)
        case .phoneNumber:
            // 010-숫자4개-숫자4개 형식
            let phoneNumberRegex = "010-([0-9]{4})-([0-9]{4})"
            let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
            return phoneNumberPredicate.evaluate(with: value)
        case .email:
            // 로컬부분(@앞부분)은 대문자, 소문자, 숫자, 특수문자 모두 가능
            // 도메인 부분(@뒷부분)은 '.' 앞으로는 대문자 소문자 숫자 '.','-' 가능, '.' 뒤로는 대문자 소문자만 가능하며 2~64자
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: value)
        }
    }
    
    /// 유저 정보가 유효한 형식이 아닐 경우 에러 메시지
    func validationErrorMessage() -> String {
        switch self {
        case .nickname:
            return "닉네임은 2자 이상 8자 이하여야 하며, 특수문자 사용이 불가능 합니다."
        case .phoneNumber:
            return "유효한 전화번호 형식이 아닙니다."
        case .email:
            return "유효한 이메일 형식이 아닙니다."
        }
    }
    
    /// 유저 정보를 입력받는 텍스트 필드 기본 메시지
    func textFieldDefaultMessage()-> String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요."
        case .phoneNumber:
            return "010-1234-1234"
        case .email:
            return "이메일 주소를 입력해주세요."
        }
    }
}
