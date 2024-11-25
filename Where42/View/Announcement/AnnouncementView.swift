//
//  AnnouncementView.swift
//  Where42
//
//  Created by 이창현 on 11/17/24.
//

import SwiftUI
import Kingfisher

struct AnnouncementView: View {
  @State var showModal: Bool = false
  @State var pickedAnnouncement: Announcement? = nil
  @StateObject var announcementViewModel: AnnouncementViewModel = .init()
  var announcementList: [Announcement]
  
  var body: some View {
    VStack {
      Text("공지사항")
        .font(.GmarketBold34)
      if announcementViewModel.isListFetched {
        List {
          ForEach(announcementViewModel.announcementList) { elem in
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
        .sheet(isPresented: $showModal, content: {
          AnnouncementModalView(showModal: $showModal, announcement: $pickedAnnouncement)
        })
      } else {

        Spacer()

        ProgressView()

        Spacer()
      }
    }
    .task {
      await announcementViewModel.getAnnouncementList()
    }
  }
}

#Preview {
  AnnouncementView(announcementList: Announcement.sampleData)
}
