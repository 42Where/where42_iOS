//
//  AnnouncementViewModel.swift
//  Where42
//
//  Created by 이창현 on 11/20/24.
//

import Foundation

class AnnouncementViewModel: ObservableObject {

  @Published var announcementList: [Announcement] = []
  @Published var isListFetched: Bool = false
  
  private let announcementAPI = AnnouncementAPI.shared
  
  func getAnnouncementList() async {
    do {
      let retList = try await announcementAPI.getAnnouncementList()
      DispatchQueue.main.async {
        self.announcementList = retList
        self.isListFetched = true
      }
    } catch API.NetworkError.Reissue {
      DispatchQueue.main.async {
          MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
      }
    } catch {
      API.errorPrint(error, message: "Failed to get announcement list")
    }
  }
}
