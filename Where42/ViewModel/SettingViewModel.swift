//
//  SettingViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/10/23.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var isLogoutAlertPresented = false
    @Published var isCommentAlertPresented = false
    @Published var isInitCommentAlertPresented = false
    @Published var isCustomLocationAlertPresented = false
    @Published var isCustomLocationAlertPresentedInHome = false
    @Published var isInitCustomLocationAlertPrsented = false
    @Published var isUserGuidePresented = false
    @Published var isAppFeedbackPresented = false
    @Published var inputText = ""
    @Published var newComment = "수정중..."
    @Published var newLocation = "수정중..."

    @Published var selectedFloor = 0
    @Published var selectedLocation = ""
    @Published var customLocation = "지하"

    let defaultFloor = ["지하", "1층", "2층", "3층", "4층", "5층", "옥상"]
    let defaultLocation = [
        [],
        ["42LAB", "오픈스튜디오", "오락실"],
        ["1클러스터", "2클러스터", "회의실", "사각테이블", "원형테이블", "직선테이블", "테라스"],
        ["x1클러스터", "x2클러스터", "반원테이블", "중앙테이블", "직선테이블", "테라스"],
        ["3클러스터", "4클러스터", "회의실", "원형테이블", "직선테이블"],
        ["5클러스터", "6클러스터", "집현전", "원형테이블", "직선테이블"],
        ["탁구대", "야외정원"]
    ]

    private let memberAPI = MemberAPI.shared
    private let loginAPI = LoginAPI.shared

    func updateComment() async -> String? {
        if inputText != "" && inputText.trimmingCharacters(in: .whitespaces) == "" {
            return "wrongComment"
        } else if inputText.count > 40 {
            return "longComment"
        }

        do {
            if inputText == "" {
                try await memberAPI.deleteComment()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.newComment = ""
                }
                return nil
            }

            if let comment = try await memberAPI.updateComment(comment: inputText) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.newComment = comment
                    self.inputText = ""
                }
            }
        } catch NetworkError.Reissue {
            return "reissue"
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to update status message")
        }
        return nil
    }

    func deleteComment() async -> Bool? {
        do {
            try await memberAPI.deleteComment()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.newComment = ""
            }
            return true
        } catch NetworkError.Reissue {
            return false
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to delete status message")
        }
        return nil
    }

    func initCustomLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectedFloor = 0
            self.selectedLocation = ""
        }
    }

    func setCustomLocation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.selectedFloor == 6 || self.selectedLocation == "집현전" || self.selectedLocation == "42LAB" || self.selectedLocation.contains("클러스터") == true {
                self.customLocation = self.selectedLocation
            } else if self.selectedFloor != 0 && self.selectedLocation != "" {
                self.customLocation = self.defaultFloor[self.selectedFloor] + " " + self.selectedLocation
            }
        }
    }

    func UpdateCustomLocation() async -> String? {
        do {
            setCustomLocation()
            if let responseCustomLocation = try await memberAPI.updateCustomLocation(customLocation: customLocation) {
                if responseCustomLocation.contains("http") == false {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.newLocation = responseCustomLocation
                        withAnimation {
                            self.isCustomLocationAlertPresented = false
                            self.isCustomLocationAlertPresentedInHome = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        MainViewModel.shared.is42IntraSheetPresented = true
                    }
                    return nil
                    // 자리를 업데이트 할 수 없습니다
                }
                initCustomLocation()
            }
        } catch NetworkError.Reissue {
            return "reissue"
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to update custom location")
        }
        return nil
    }

    func resetCustomLocation() async -> String? {
        do {
            if let status = try await memberAPI.deleteCustomLocation() {
                if status == true {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.newLocation = "개포"
                        withAnimation {
                            self.isInitCustomLocationAlertPrsented = false
                            self.isCustomLocationAlertPresented = false
                            self.isCustomLocationAlertPresentedInHome = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        MainViewModel.shared.is42IntraSheetPresented = true
                    }
                    return nil
                    // 자리를 업데이트 할 수 없습니다
                }
                initCustomLocation()
            }
        } catch NetworkError.Reissue {
            return "reissue"
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to delete custom location")
        }
        return nil
    }

    func logout() async {
        do {
            try await loginAPI.logout()
            KeychainManager.deleteToken(key: "accessToken")
            if let _ = KeychainManager.readToken(key: "intraId") {
                KeychainManager.deleteToken(key: "intraId")
            }
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to logout")
        }
    }
}
