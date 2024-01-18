//
//  SettingViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/10/23.
//

import SwiftUI

extension SettingView {
    class SettingViewModel: ObservableObject {
        @Published var isLogoutAlertPresent = false
        @Published var isStatusMessageAlertPresent = false
        @Published var isCustomLocationAlertPresent = false
        @Published var isIntraPresented = false
        @Published var inputText = ""
        @Published var newStatusMessage = "수정중..."
        @Published var newLocation = "수정중..."
        @Published var intraURL = ""

        private let memberAPI = MemberAPI()

        func UpdateComment(intraId: Int) async {
            do {
                if let comment = try await memberAPI.updateStatusMessage(statusMessage: inputText) {
                    DispatchQueue.main.async {
                        if comment.contains("http") == false {
                            self.newStatusMessage = comment
                            self.inputText = ""
                        } else {
                            self.intraURL = comment
                            self.isIntraPresented = true
                            // 상태메세지를 업데이트 할 수 없습니다
                        }
                    }
                }
            } catch {}
        }

        func UpdateCustomLocation(intraId: Int) async -> Bool {
            if inputText == "" {
                return false
            }

            do {
                if let customLocation = try await memberAPI.updateCustomLocation(customLocation: inputText) {
                    DispatchQueue.main.async {
                        if customLocation.contains("http") == false {
                            self.newLocation = customLocation
                            self.inputText = ""
                        } else {
                            self.intraURL = customLocation
                            self.isIntraPresented = true
                            // 자리를 업데이트 할 수 없습니다
                        }
                    }
                }
            } catch {}
            return true
        }
    }
}
