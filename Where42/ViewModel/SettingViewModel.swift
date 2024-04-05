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

        if inputText == "" {
            do {
                try await memberAPI.deleteComment()
                DispatchQueue.main.async {
                    self.newComment = ""
                }
                return nil
            } catch API.NetworkError.Reissue {
                return "reissue"
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }

        do {
            if let comment = try await memberAPI.updateComment(comment: inputText) {
                if comment.contains("http") == false {
                    DispatchQueue.main.async {
                        self.newComment = comment
                        self.inputText = ""
                    }
                } else {
                    DispatchQueue.main.async {
                        MainViewModel.shared.is42IntraSheetPresented = true
                    }
                    return "reissue"
                    // 상태메세지를 업데이트 할 수 없습니다
                }
            }
        } catch API.NetworkError.Reissue {
            return "reissue"
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    func deleteComment() async -> Bool? {
        do {
            try await memberAPI.deleteComment()
            DispatchQueue.main.async {
                self.newComment = ""
            }
            return true
        } catch API.NetworkError.Reissue {
            return false
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func initCustomLocation() {
        DispatchQueue.main.async {
            self.selectedFloor = 0
            self.selectedLocation = ""
        }
    }

    func setCustomLocation() {
        DispatchQueue.main.async {
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
                    DispatchQueue.main.async {
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
        } catch API.NetworkError.Reissue {
            return "reissue"
        } catch {}
        return nil
    }

    func resetCustomLocation() async -> String? {
        do {
            if let status = try await memberAPI.deleteCustomLocation() {
                if status == true {
                    DispatchQueue.main.async {
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
        } catch API.NetworkError.Reissue {
            return "reissue"
        } catch {}
        return nil
    }

    func logout() async {
        do {
            try await loginAPI.logout()
        } catch {}
    }
}
