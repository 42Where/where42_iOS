//
//  SettingViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/10/23.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @Published var isLogoutAlertPresent = false
    @Published var isStatusMessageAlertPresent = false
    @Published var isCustomLocationAlertPresent = false
    @Published var isIntraPresented = false
    @Published var inputText = ""
    @Published var newStatusMessage = "수정중..."
    @Published var newLocation = "수정중..."
    @Published var intraURL = ""
    @Published var selectedFloor = 0
    @Published var selectedLocation = ""
    @Published var customLocation = ""

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

    private let memberAPI = MemberAPI()

    func UpdateComment() async -> String? {
        if inputText == "" || inputText.trimmingCharacters(in: .whitespaces) == "" {
            return "wrong"
        }
        if inputText.count > 40 {
            return "long"
        }

        do {
            if let comment = try await memberAPI.updateStatusMessage(statusMessage: inputText) {
                DispatchQueue.main.async {
                    print(comment)
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
        return nil
    }

    func initCustomLocation() {
        selectedFloor = 0
        selectedLocation = ""
    }

    func setCustomLocation(location: String) {
        if selectedFloor == 6 || location == "집현전" || location == "42LAB" {
            customLocation = location
        } else if selectedFloor != 0 {
            customLocation = customLocation + " " + location
        }
        print(customLocation)
    }

    func UpdateCustomLocation() async {
        do {
            if let responseCustomLocation = try await memberAPI.updateCustomLocation(customLocation: customLocation) {
                DispatchQueue.main.async {
                    if responseCustomLocation.contains("http") == false {
                        self.newLocation = responseCustomLocation
                        withAnimation {
                            self.isCustomLocationAlertPresent = false
                        }
                    } else {
                        self.intraURL = responseCustomLocation
                        self.isIntraPresented = true
                        // 자리를 업데이트 할 수 없습니다
                    }
                    self.initCustomLocation()
                }
            }
        } catch {}
    }
}
