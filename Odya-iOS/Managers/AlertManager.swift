//
//  AlertManager.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/11/06.
//

import SwiftUI

class AlertManager: ObservableObject {
    @Published var showAlertOfTravelJournalCreation: Bool = false
    @Published var showFailureAlertOfTravelJournalCreation: Bool = false
    
}
