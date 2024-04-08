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

    @State private var message: String! = ""

    var body: some View {
        if settingViewModel.isLogoutAlertPresented {
            CustomAlert(
                title: "로그아웃",
                message: "로그아웃 하시겠습니까?",
                inputText: .constant("")
            ) {
                withAnimation {
                    settingViewModel.isLogoutAlertPresented = false
                }
            } rightButtonAction: {
                await self.settingViewModel.logout()
                KeychainManager.deleteToken(key: "accessToken")
                KeychainManager.deleteToken(key: "refreshToken")
                withAnimation {
                    self.settingViewModel.isLogoutAlertPresented = false
                    mainViewModel.isLogin = false
                }
            }
        }

        if settingViewModel.isCommentAlertPresented {
            CustomAlert(
                title: "코멘트 변경",
                inputText: $settingViewModel.inputText,
                textFieldTitle: "코멘트를 입력해주세요"
            ) {
                withAnimation {
                    settingViewModel.isCommentAlertPresented = false
                }
            } rightButtonAction: {
                let status = await settingViewModel.updateComment()

                if status == nil {
                    withAnimation {
                        settingViewModel.isCommentAlertPresented = false
                    }
                    homeViewModel.myInfo.comment = settingViewModel.newComment
                } else {
                    mainViewModel.setToast(type: status)
                }
            } initButtonAction: {
                withAnimation {
                    settingViewModel.isInitCommentAlertPresented = true
                }
            }
        }

        if settingViewModel.isInitCommentAlertPresented {
            CustomAlert(
                title: "코멘트 초기화",
                message: "코멘트를 초기화 하시겠습니까?",
                inputText: .constant("")
            ) {
                withAnimation {
                    settingViewModel.isInitCommentAlertPresented = false
                }
            } rightButtonAction: {
                let status = await settingViewModel.deleteComment()

                if status == true {
                    withAnimation {
                        settingViewModel.isInitCommentAlertPresented = false
                        settingViewModel.isCommentAlertPresented = false
                    }
                    homeViewModel.myInfo.comment = settingViewModel.newComment
                } else {
                    mainViewModel.setToast(type: "reissue")
                }
            }
        }

        if settingViewModel.isCustomLocationAlertPresented {
            CustomLocationView()
        }
    }
}

#Preview {
    SettingAlert()
}
