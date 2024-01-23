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

    let defaultFloor = ["", "1층", "2층", "3층", "4층", "5층", "B1 / 옥상"]
    let defaultLocation = [
        [],
        ["오픈 스튜디오", "오픈 라운지", "42LAB", "유튜브 스튜디오"],
        ["유튜브 스튜디오", "오아시스", "회의실A", "회의실B", "스톤테이블", "기타 학습공간"],
        ["오아시스", "다각형 책상A", "다각형 책상B"],
        ["오아시스", "회의실A", "회의실B", "스톤테이블", "기타 학습공간"],
        ["오아시스", "좌식공간", "스톤 테이블", "기타 학습공간"],
        ["오픈 스튜디오", "탁구대", "야외정원", "기타 학습공간"]
    ]

    private let memberAPI = MemberAPI()

    func UpdateComment() async {
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

    func initCustomLocation() {
        selectedFloor = 0
        selectedLocation = ""
    }

    func setCustomLocation(location: String) {
        if selectedFloor != 6 {
            customLocation = defaultFloor[selectedFloor] + " " + location
        } else {
            if location == "오픈 스튜디오" || location == "기타 학습공간" {
                customLocation = "B1 " + location
            } else {
                customLocation = location
            }
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
