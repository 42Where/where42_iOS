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
        @Published var inputText = ""
        @Published var newStatusMessage: String = "수정중..."
        @Published var newCustomLocation: String = "수정중..."

        private let memberAPI = MemberAPI()

        func UpdateComment(intraId: Int) async {
            do {
                if let comment = try await memberAPI.updateStatusMessage(intraId: intraId, statusMessage: inputText) {
                    DispatchQueue.main.async {
                        self.newStatusMessage = comment
                        self.inputText = ""
                    }
                }
            } catch {}
        }

        func UpdateCustomLocation(intraId: Int) async {
            do {
                if let customLocation = try await memberAPI.updateCustomLocation(intraId: intraId, customLocation: inputText) {
                    DispatchQueue.main.async {
                        self.newCustomLocation = customLocation
                        self.inputText = ""
                    }
                }
            } catch {}
        }
    }
}
