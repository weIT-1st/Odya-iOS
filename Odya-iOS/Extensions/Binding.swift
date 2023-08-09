//
//  Binding.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/08/10.
//

import SwiftUI

/// Binding<T> 변수에 대해 옵셔널을 해제
extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
