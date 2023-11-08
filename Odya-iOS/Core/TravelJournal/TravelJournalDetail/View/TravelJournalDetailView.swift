//
//  TravelJournalDetailView.swift
//  Odya-iOS
//
//  Created by Heeoh Son on 2023/09/26.
//

import SwiftUI

struct TravelJournalDetailView: View {
  //  @State var selectedDetent: PresentationDetent = .journalDetailOff
  //  private let availableDetent: Set<PresentationDetent> = [.journalDetailOff, .journalDetailOn]
    @Environment(\.dismiss) var dismiss
    
  @StateObject var bottomSheetVM = BottomSheetViewModel()
  @StateObject var journalDetailVM = TravelJournalDetailViewModel()

  let journalId: Int
    
    @State private var isShowingJournalDeletionAlert: Bool = false
    @State private var isShowingJournalDeletionFailureAlert: Bool = false
    @State private var failureMessage: String = ""
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // map
                Color.odya.brand.primary
                    .ignoresSafeArea()
                
                headerBar
                
                if let journalDetail = journalDetailVM.journalDetail {
                    JournalDetailBottomSheet(travelJournal: journalDetail)
                        .environmentObject(bottomSheetVM)
                        .environmentObject(journalDetailVM)
                        .frame(height: UIScreen.main.bounds.height)
                        .offset(y: bottomSheetVM.minHeight)
                        .offset(y: bottomSheetVM.sheetOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation {
                                        if !bottomSheetVM.isSheetOn && bottomSheetVM.isScrollAtTop {
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
                } else {
                    VStack {
                        Spacer()
                        ProgressView()
                            .frame(height: 250)
                    }
                }
            }  // geometry
        }
        .onAppear {
            journalDetailVM.getJournalDetail(journalId: journalId)
            bottomSheetVM.isSheetOn = false
            // selectedDetent = .journalDetailOff
        }
        .alert("해당 여행일지를 삭제할까요?", isPresented: $isShowingJournalDeletionAlert) {
            HStack {
              Button("취소", role: .cancel) {
                  isShowingJournalDeletionAlert = false
              }
              Button("삭제", role: .destructive) {
                  isShowingJournalDeletionAlert = false
                  journalDetailVM.deleteJournal(journalId: journalId) { success, errMsg in
                      if success {
                          print("delete")
                          dismiss()
                      } else {
                          failureMessage = errMsg
                          isShowingJournalDeletionFailureAlert = true
                      }
                      
                  }
              }
            }
          } message: {
            Text("삭제된 내용은 복구될 수 없습니다.")
          }
          .alert(failureMessage, isPresented: $isShowingJournalDeletionFailureAlert) {
              Button("확인") {
                  isShowingJournalDeletionFailureAlert = false
                  failureMessage = ""
              }
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
            // print("clicked")
          }
            Menu {
                Button("편집하기") { print("edit") }
                Button("삭제하기", role: .destructive) {
                    isShowingJournalDeletionAlert = true
                }
            } label: {
                IconButton("menu-kebab-l") {}
            }
          
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
    MyJournalsView()
    // TravelJournalDetailView(journalId: 1)
  }
}
