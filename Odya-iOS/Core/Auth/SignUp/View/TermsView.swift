//
//  TermsView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/13.
//

import SwiftUI

struct TermsView: View {
  
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
  
  // user info
  @Binding var signUpStep: Int
  @Binding var termsList: [Int]
  
  // permissions
  let permissions: [Permission]
  = [Permission("카메라", "촬영과 이미지 등 콘텐츠를 사용할 수 있어요", "camera"),
     Permission("기기 및 앱 기록", "여행 동선을 간편하게 기록할 수 있어요", "trip"),
     Permission("GPS", "여행일지와 커뮤니티에 장소를 태그할 수 있어요", "gps"),
     Permission("저장소 접근 권한", "기기내에 이미지 파일을 업로드할 수 있어요", "grid"),
     Permission("앱 푸쉬 알림", "게시물의 오댜, 댓글, 태그 상태를 알 수 있어요", "alarm-off"),
     Permission("연락처", "연락처 기반 친구추천을 받을 수 있어요", "call")]
     
  // terms
  var selectedTerms: Terms? {
    viewModel.termsList.first
  }
  
  // terms 가 여러 개일 때
  // @State private var selectedTerms: Terms
  
  @State var showSheet: Bool = false
  
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
      
      titleText
      
      Spacer()
      
      VStack(spacing: 13) {
        ForEach(permissions, id: \.id) { permission in
          self.generatePermissionDescriptionView(permission)
        }
      }
      
      Spacer()
      
      CTAButton(isActive: .active, buttonStyle: .solid, labelText: "오댜 시작하기", labelSize: .L) {
        showSheet.toggle()
      }
      .padding(.bottom, 45)
    }  // VStack
    .padding(.horizontal, GridLayout.side)
    .task {
      viewModel.getTermsList()
    }
    .sheet(isPresented: $showSheet) {
      self.generateTermsContetnSheet()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .environmentObject(viewModel)
    }
  }
  
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

extension TermsView {
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

extension TermsView {
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
