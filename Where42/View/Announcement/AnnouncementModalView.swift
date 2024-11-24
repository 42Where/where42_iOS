//
//  AnnouncementModalView.swift
//  Where42
//
//  Created by 이창현 on 11/22/24.
//

import SwiftUI

struct AnnouncementModalView: View {

  @Binding var showModal: Bool
  @Binding var announcement: Announcement?

  var body: some View {
    VStack {
      
      Image("Logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 50)
      
      Spacer(minLength: 30)
      
      Text(announcement?.title ?? "")
        .font(.GmarketBold34)

      Spacer(minLength: 30)
      
      ZStack {
        Text(announcement?.content ?? "")
          .font(.GmarketLight34)
        Rectangle()
          .fill(Color.clear)
          .border(Color.whereDeepPink, width: 1)
      }

      Spacer(minLength: 30)

      HStack {
        Spacer()
        Text("작성일 : \(announcement?.createAt ?? "")\n수정일 : \(announcement?.updateAt ?? "")")
          .font(.GmarketLight14)
      }
      .padding()
      
      Spacer(minLength: 30)
      
      Button(action: {
        self.showModal = false
      }, label: {
        Text("닫기")
          .font(.GmarketLight18)
          .frame(width: 120, height: 50)
          .background(Color.whereDeepNavy)
          .foregroundStyle(Color.white)
          .cornerRadius(10)
      })
    }
    .padding(EdgeInsets(NSDirectionalEdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20)))
  }
}

#Preview {
  AnnouncementModalView(showModal: .constant(true), announcement: .constant(Announcement.sampleData[0]))
}
