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
    
    private let announcementAPI = AnnouncementAPI()
    
    func getAnnouncementList() async {
        do {
            let retList = try await announcementAPI.getAnnouncementList()
            await setAnnouncementListOnUI(retList)
        } catch NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to get announcement list")
        }
    }
    
    @MainActor
    private func setAnnouncementListOnUI(_ retList: [Announcement]) {
        self.announcementList = retList
        self.isListFetched = true
    }
}
