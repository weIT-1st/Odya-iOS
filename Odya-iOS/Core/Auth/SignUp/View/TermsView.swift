//
//  TermsView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/13.
//

import SwiftUI

/// 앱에서 사용되는 권한 및 약관에 대해 설명이 포함된 뷰
/// 권한과 약관에 대해 사용자의 동의를 얻어냄
struct TermsView: View {
  
  /// 권한 내용 set
  /// 권한 종류, 권한이 필요한 이유, 권한 아이콘 이미지
  struct Permission: Identifiable {
    let id = UUID()
    let type: String
    let purpose: String
    let imageName: String
    
    init(_ type: String, _ purpose: String, _ imageName: String) {
      self.type = type
      self.purpose = purpose
      self.imageName = imageName
    }
  }
  
  // MARK: Properties

  @StateObject var viewModel = TermsViewModel()
  
  /// 회원가입 단계
  @Binding var signUpStep: Int
  
  /// 사용자가 동의한 terms 리스트
  @Binding var termsList: [Int]
  
  // permissions
  let permissions: [Permission]
  = [Permission("카메라", "촬영과 이미지 등 콘텐츠를 사용할 수 있어요", "camera"),
     Permission("기기 및 앱 기록", "여행 동선을 간편하게 기록할 수 있어요", "trip"),
     Permission("GPS", "여행일지와 커뮤니티에 장소를 태그할 수 있어요", "gps"),
     Permission("저장소 접근 권한", "기기내에 이미지 파일을 업로드할 수 있어요", "grid"),
     Permission("앱 푸쉬 알림", "게시물의 오댜, 댓글, 태그 상태를 알 수 있어요", "alarm-off"),
     Permission("연락처", "연락처 기반 친구추천을 받을 수 있어요", "call")]
     
  /// terms
  var selectedTerms: Terms? {
    viewModel.termsList.first
  }
  
  /// terms 가 여러 개일 때, 선택된 terms
  // @State private var selectedTerms: Terms
  
  /// terms 내용을 보여주고 동의를 얻을 수 있는 바텀시트 표시 여부
  @State var showSheet: Bool = false
  
  /// 모든 필수 terms 동의를 받았는지 여부
  /// 현재 terms 가 하나이기 때문에 사용되고 있지 않음
  private var isNextButtonActive: ButtonActiveSate {
    return (termsList.contains(viewModel.requiredList) && !viewModel.requiredList.isEmpty) ? .active : .inactive
  }
  
  init(_ signUpStep: Binding<Int>, myTermsIdList: Binding<[Int]>) {
    self._signUpStep = signUpStep
    self._termsList = myTermsIdList
  }

  // MARK: Body

  var body: some View {
    VStack {
      Spacer()
      
      // 권한 뷰 title
      titleText
      
      Spacer()
      
      // 필요한 권한 리스트
      VStack(spacing: 13) {
        ForEach(permissions, id: \.id) { permission in
          self.generatePermissionDescriptionView(permission)
        }
      }
      
      Spacer()
      
      // 다음 회원가입 단계로 넘어가는 버튼
      CTAButton(isActive: .active, buttonStyle: .solid, labelText: "오댜 시작하기", labelSize: .L) {
        showSheet.toggle()
      }
      .padding(.bottom, 45)
    }  // VStack
    .padding(.horizontal, GridLayout.side)
    .task {
      // 서버에서 terms 리스트 받아오기
      viewModel.getTermsList()
    }
    .sheet(isPresented: $showSheet) {
      self.generateTermsContetnSheet()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .environmentObject(viewModel)
    }
  }
  
  // MARK: title
  private var titleText: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("더 나은 서비스를 위해서 \n권한 동의가 필요해요")
        .h3Style()
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("권한을 허용하지 않으면 일부 서비스가 제한될 수 있습니다")
        .detail1Style()
        .foregroundColor((.odya.label.assistive))
        .frame(height: 9)
    }.frame(width: 335)
  }
}

// MARK: Premission Description View
extension TermsView {
  /// 사용되는 권한에 대한 설명 뷰
  func generatePermissionDescriptionView(_ permission: Permission) -> some View {
    return HStack(spacing: 36) {
      Image(permission.imageName)
      
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text(permission.type)
            .b1Style()
            .foregroundColor(.odya.label.normal)
            .frame(height: 12)
          Spacer()
        }
        
        Text(permission.purpose)
          .detail2Style()
          .foregroundColor(.odya.label.assistive)
          .frame(height: 9)
      }
    }
    .frame(width: 335)
    .padding(10)
  }
}

// MARK: Terms Content Sheet
extension TermsView {
  /// 동의를 얻어야 하는 terms content & 동의 버튼
  func generateTermsContetnSheet() -> some View {
    VStack(spacing: GridLayout.spacing) {
      if let terms = selectedTerms {
        // title
        HStack {
          Text(terms.title)
            .h3Style()
            .foregroundColor(Color.odya.label.normal)
            .padding(.top, 20)
            .padding(.vertical, 20)
          Spacer()
        }
        
        // content
        HTMLTextView(htmlContent: viewModel.termsContent,
                     backgroundColor: UIColor(.odya.background.normal),
                     textColor: UIColor(.odya.label.normal),
                     font: UIFont(name: "NotoSansKR-Regular", size: 32)!
        ).previewLayout(.sizeThatFits)
        
        Spacer()
        
        // consent button
        CTAButton(
          isActive: viewModel.termsContent == "" ? .inactive : .active, buttonStyle: .solid,
          labelText: "동의하고 시작하기", labelSize: .L
        ) {
          termsList.append(terms.id)
          showSheet = false
          signUpStep += 1
        }
        .task {
          viewModel.getTermsContent(id: terms.id)
        }.padding(.bottom)
      } else {
        ProfileView()
      }
    }
    .padding(.horizontal, GridLayout.side)
    .frame(width: UIScreen.main.bounds.width)
    .background(Color.odya.background.normal)
  }
}

// MARK: - Preview

struct TermsView_Previews: PreviewProvider {
  static var previews: some View {
    TermsView(.constant(2), myTermsIdList: .constant([1, 2, 3]))
  }
}
