//
//  SettingAlert.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct SettingAlert: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @AppStorage("isLogin") var isLogin: Bool = false

    @State private var message: String! = ""

    var body: some View {
        if settingViewModel.isLogoutAlertPresent {
            CustomAlert(
                title: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                inputText: .constant("")
            ) {
                withAnimation {
                    settingViewModel.isLogoutAlertPresent = false
                }
            } rightButtonAction: {
                await self.settingViewModel.logout()
                API.sharedAPI.accessToken = ""
                withAnimation {
                    self.homeViewModel.isShowSettingSheet = false
                    self.settingViewModel.isLogoutAlertPresent = false
                    self.isLogin = false
                    self.homeViewModel.isLogout = true
                }
            }
        }

        if settingViewModel.isStatusMessageAlertPresent {
            CustomAlert(
                title: "코멘트 변경",
                inputText: $settingViewModel.inputText,
                textFieldTitle: "코멘트를 입력해주세요"
            ) {
                withAnimation {
                    settingViewModel.isStatusMessageAlertPresent = false
                    settingViewModel.inputText = ""
                }
            } rightButtonAction: {
                let status = await settingViewModel.UpdateComment()

                if status == nil {
                    withAnimation {
                        settingViewModel.isStatusMessageAlertPresent = false
                    }
                    homeViewModel.myInfo.comment = settingViewModel.newStatusMessage
                } else {
                    mainViewModel.setToast(type: status)
                }
            }
        }

        if settingViewModel.isCustomLocationAlertPresent {
            CustomLocationView()
        }
    }
}

#Preview {
    SettingAlert()
}
