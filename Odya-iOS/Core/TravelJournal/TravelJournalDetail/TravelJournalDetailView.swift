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

  @StateObject var bottomSheetVM = BottomSheetViewModel()

  // travel Journal Data || VM

  var body: some View {
    ZStack {
      GeometryReader { geometry in
        // map
        Color.odya.brand.primary
          .ignoresSafeArea()

        headerBar

        JournalDetailBottomSheet(travelJournal: TravelJournalData.getDummy())
          .environmentObject(bottomSheetVM)
          .frame(height: UIScreen.main.bounds.height)
          .offset(y: bottomSheetVM.minHeight)
          .offset(y: bottomSheetVM.sheetOffset)
          .gesture(
            DragGesture()
              .onChanged { value in
                withAnimation {
                  if !bottomSheetVM.isSheetOn {
                    bottomSheetVM.sheetOffset = value.translation.height
                  } else if bottomSheetVM.isScrollAtTop {
                    print(value.translation.height)
                  }
                }
              }
              .onEnded { value in
                withAnimation {
                  if !bottomSheetVM.isSheetOn || bottomSheetVM.isScrollAtTop {
                    bottomSheetVM.setSheetHeight(value, geometry)
                  }
                }

              }
          )
      }  // geometry
    }
    .onAppear {
      selectedDetent = .journalDetailOff
      bottomSheetVM.isSheetOn = false
    }
    .onChange(of: bottomSheetVM.isSheetOn) { newValue in
      print("isSheetOn: \(newValue)")
    }
  }

  private var headerBar: some View {
    VStack {
      ZStack {
        CustomNavigationBar(title: "")
        HStack(spacing: 8) {
          // 바텀시트 올라와 있을 경우, 백버튼 = 바텀시트 닫기 버튼
          if bottomSheetVM.isSheetOn {
            IconButton("direction-left") {
              withAnimation {
                bottomSheetVM.sheetOffset = 0
                bottomSheetVM.isSheetOn = false
              }
            }
          }
          Spacer()
          IconButton("star-off") {
            print("clicked")
          }
          IconButton("menu-kebab-l") {}
        }
        .padding(.leading, 8)
        .padding(.trailing, 12)
      }

      Spacer()
    }
  }

}

struct TravelJournalDetailView_Previews: PreviewProvider {
  static var previews: some View {
    TravelJournalDetailView()
  }
}
