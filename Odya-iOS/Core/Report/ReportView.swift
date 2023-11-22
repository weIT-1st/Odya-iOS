//
//  ReportView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/11/22.
//

import SwiftUI

/// 신고할 타겟
/// ReportView 재사용 위해 뷰 생성시 타겟을 파라미터로 넣어줍니다.
enum ReportTargetType {
  case placeReview
  case travelJournal
  case community
}

struct ReportView: View {
  // MARK: Properties
  
  /// 신고 대상의 타입
  let reportTarget: ReportTargetType
  /// 신고할 글의 ID
  let id: Int
  /// 뷰 토글
  @Binding var isPresented: Bool
  
  /// 선택한 신고사유
  @State private var selectedReason: ReportReason? = nil
  /// 뷰모델
  @StateObject private var viewModel = ReportViewModel()
  
  // MARK: Body
  
  var body: some View {
    VStack(spacing: 0) {
      header
      VStack(spacing: 0) {
        writerView
          .padding(.vertical, 56)
        HStack {
          Text("사유선택")
            .b2Style()
            .foregroundColor(.odya.label.alternative)
          Spacer()
        }
        .padding(.bottom, GridLayout.spacing)
        
        ForEach(ReportReason.allCases, id: \.status) { reason in
          ReportReasonCell(selectedReason: $selectedReason, reason: reason)
        }
        
        otherReasonTextField
        Spacer()
        
        // 신고하기 버튼
        CTAButton(isActive: selectedReason != nil ? .active : .inactive, buttonStyle: .solid, labelText: "신고하기", labelSize: .L) {
          // action: 신고하기
          viewModel.createReport(target: reportTarget, id: id, reason: selectedReason!)
        }
        .disabled(selectedReason == nil)
        .padding(.bottom, 32)
      }
      .padding(.horizontal, GridLayout.side)
    }
    .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
      Button("닫기", role: .cancel) {
        self.isPresented = false
      }
    } message: {
      Text(viewModel.alertMessage)
    }

  }
  
  /// 헤더
  private var header: some View {
    ZStack(alignment: .center) {
      HStack {
        Text("신고하기")
          .h6Style()
          .multilineTextAlignment(.center)
          .foregroundColor(.odya.label.normal)
      }
      HStack {
        Spacer()
        IconButton("x") {
          // action: 닫기
          isPresented = false
        }
        .frame(width: 36, height: 36)
      }
      .padding(.trailing, 12)
    }
    .frame(height: 56)
  }
  
  /// 작성자
  private var writerView: some View {
    HStack(alignment: .center) {
      Text("작성자")
        .h6Style()
        .foregroundColor(.odya.label.normal)
      Rectangle()
      .foregroundColor(.clear)
      .frame(width: 1, height: 15)
      .background(Color.odya.line.normal)
      Text(MyData().nickname)
        .b2Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
    }
  }
  
  /// 기타사유 입력 텍스트필드
  private var otherReasonTextField: some View {
    VStack(spacing: 0) {
      TextField("기타 사유를 입력해주세요 (20자 이내)", text: $viewModel.otherReasonText)
        .frame(height: 56)
      Divider()
    }
    .frame(maxWidth: .infinity)
  }
}

/// 신고사유 선택 셀
struct ReportReasonCell: View {
  @Binding var selectedReason: ReportReason?
  let reason: ReportReason
  @State var isChecked: checkboxState = .disabled
  
  var body: some View {
    HStack(spacing: 10) {
      CheckboxButton(state: $isChecked)
        .frame(width: 24, height: 24)
        .padding(8)
        .onTapGesture {
          selectedReason = reason
        }
      Text(reason.value)
        .b1Style()
        .foregroundColor(.odya.label.normal)
      Spacer()
    }
    .frame(height: 40, alignment: .leading)
    .frame(maxWidth: .infinity)
    .onChange(of: selectedReason) { newValue in
      if selectedReason == reason {
        isChecked = .selected
      } else {
        isChecked = .disabled
      }
    }
  }
}

// MARK: - Previews
struct ReportView_Previews: PreviewProvider {
  static var previews: some View {
    ReportView(reportTarget: .community, id: 1, isPresented: .constant(true))
  }
}
