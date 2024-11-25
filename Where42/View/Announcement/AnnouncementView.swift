//
//  AnnouncementView.swift
//  Where42
//
//  Created by 이창현 on 11/17/24.
//

import SwiftUI

struct AnnouncementView: View {
  @State var showModal: Bool = false
  @State var pickedAnnouncement: Announcement? = nil
  @StateObject var announcementViewModel: AnnouncementViewModel = AnnouncementViewModel()
  var announcementList: [Announcement]
  
  var body: some View {
    VStack {
      Spacer()
      Text("공지사항")
        .font(.GmarketBold34)
      List {
        ForEach(announcementList) { elem in
          Button(action: {
            self.pickedAnnouncement = elem
            self.showModal = true
          }, label: {
            HStack {
              Text("\(elem.title)")
                .font(.GmarketBold14)
                .foregroundStyle(.whereMediumNavy)
              Spacer()
              Text("\(elem.createAt)")
                .font(.GmarketLight14)
                .foregroundStyle(.whereMediumNavy)
                .monospaced()
            }
          })
        }
      }
      .task {
        await announcementViewModel.getAnnouncementList()
      }
      .sheet(isPresented: $showModal, content: {
          AnnouncementModalView(showModal: $showModal, announcement: $pickedAnnouncement)
      })
    }
  }
}

#Preview {
  AnnouncementView(announcementList: Announcement.sampleData)
}
