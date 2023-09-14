//
//  TermsView.swift
//  Odya-iOS
//
//  Created by Jade Yoo on 2023/09/13.
//

import SwiftUI

struct TermsView: View {
  // MARK: Properties
  
  @StateObject var viewModel = TermsViewModel()
  @State var showSheet: Bool = false
  @Binding var termsList: [Int]
  
  // MARK: Body
  
  var body: some View {
    VStack {
      Text("약관 안내")
        .h3Style()
      
      List(viewModel.termsList, id: \.id) { terms in
        HStack {
          Image(systemName: "checkmark")
            .foregroundColor(termsList.contains(terms.id) ? Color.odya.system.safe : Color.odya.system.inactive)
          
          if terms.isRequired {
            Text("(필수)")
              .detail1Style()
          } else {
            Text("(선택)")
              .detail2Style()
          }
          
          Text(terms.title)
          Spacer()
          Button {
            showSheet.toggle()
          } label: {
            Text("보기")
          }
        }
        .sheet(isPresented: $showSheet) {
          TermsContentSheet(id: terms.id, title: terms.title)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .environmentObject(viewModel)
        }
      } // List
      
      CTAButton(isActive: .active, buttonStyle: .solid, labelText: "다음으로", labelSize: .L) {
        // 다음 페이지로
      }
      .disabled(!termsList.contains(viewModel.requiredList) || viewModel.requiredList.isEmpty)
    } // VStack
    .task {
      viewModel.getTermsList()
    }
  }
}

struct TermsContentSheet: View {
  // MARK: Properties
  @EnvironmentObject var viewModel: TermsViewModel
  @Environment(\.dismiss) var dismiss
  let id: Int
  let title: String
  
  // MARK: Body
  
  var body: some View {
    VStack(spacing: GridLayout.spacing) {
      // title
      HStack {
        Text(title)
          .h3Style()
          .foregroundColor(Color.odya.label.normal)
          .padding(.vertical, 20)
        Spacer()
      }
      // content
      HTMLTextView(htmlContent: viewModel.termsContent)
      Spacer()
      // consent button
      CTAButton(isActive: .active, buttonStyle: .solid,
                labelText: "동의하기", labelSize: .L) {
        dismiss()
      }
    }
    .padding(.horizontal, GridLayout.side)
    .frame(width: UIScreen.main.bounds.width)
    .background(Color.odya.background.normal)
    .task {
      viewModel.getTermsContent(id: id)
    }
  }
}

// MARK: - Preview

struct TermsView_Previews: PreviewProvider {
  static var previews: some View {
    TermsView(termsList: [1, 2 ,3])
  }
}
