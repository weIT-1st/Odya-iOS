//
//  TravelJournalDetailView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/26.
//

import SwiftUI

struct TravelJournalDetailView: View {
    @State var selectedDetent: PresentationDetent = .journalDetailOff
    private let availableDetent: Set<PresentationDetent> = [.journalDetailOff, .journalDetailOn]
    
    // travel Journal Data || VM
    
    var body: some View {
        ZStack {
            // map
            Color.odya.brand.primary
                .ignoresSafeArea()
            
            // header bar
            VStack {
                ZStack {
                    CustomNavigationBar(title: "")
                    HStack(spacing: 8) {
                        Spacer()
                        IconButton("star-off") {}
                        IconButton("menu-kebab-l") {}
                    }.padding(.trailing, 12)
                }
                Spacer()
            }
        }
        .onAppear {
            selectedDetent = .journalDetailOff
        }
        .sheet(isPresented: .constant(true)) {
            JournalDetailBottomSheet(isSheetOn: $selectedDetent, travelJournal: TravelJournalData.getDummy())
                .presentationDetents(availableDetent, selection: $selectedDetent)
                .interactiveDismissDisabled()
                .setModalBackground(Color.odya.background.dimmed_system)
        }
        
    }
}

struct TravelJournalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TravelJournalDetailView()
    }
}
