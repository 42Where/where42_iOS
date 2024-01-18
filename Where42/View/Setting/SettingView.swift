//
//  Setting.swift
//  Where42
//
//  Created by 현동호 on 10/29/23.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var settingViewModel: SettingViewModel = .init()
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("token") var token = ""

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("환경설정")
                    .font(.GmarketBold34)
                
                Spacer()
                
                Button("로그아웃") {
                    withAnimation {
                        settingViewModel.isLogoutAlertPresent = true
                    }
                }
                .buttonStyle(setButton())

                Spacer()
                
//                Button("자리비움") {}
//                    .buttonStyle(setButton())
//
//                Spacer()
                
                Button("코멘트 설정") {
                    withAnimation {
                        settingViewModel.isStatusMessageAlertPresent = true
                    }
                }
                .buttonStyle(setButton())
                
                Spacer()
                
                Button("자리 설정") {
                    withAnimation {
                        settingViewModel.isCustomLocationAlertPresent = true
                    }
                }
                .buttonStyle(setButton())
                
                Spacer()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .fullScreenCover(isPresented: $settingViewModel.isIntraPresented, content: {
                MyWebView(urlToLoad: settingViewModel.intraURL, isPresented: $settingViewModel.isIntraPresented)
            })
            
            if settingViewModel.isLogoutAlertPresent {
                CustomAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?", inputText: .constant("")) {
                    withAnimation {
                        settingViewModel.isLogoutAlertPresent = false
                    }
                } rightButtonAction: {
                    withAnimation {
                        homeViewModel.isShowSettingSheet = false
                        settingViewModel.isLogoutAlertPresent = false
                        isLogin = false
                        token = ""
                        homeViewModel.isLogout = true
                    }
                }
                .zIndex(1)
            }
            
            if settingViewModel.isStatusMessageAlertPresent {
                CustomAlert(title: "상태메세지 변경", textFieldTitle: "상태메세지를 입력해주세요", inputText: $settingViewModel.inputText) {
                    withAnimation {
                        settingViewModel.isStatusMessageAlertPresent.toggle()
                        settingViewModel.inputText = ""
                    }
                } rightButtonAction: {
                    withAnimation {
                        settingViewModel.isStatusMessageAlertPresent.toggle()
                    }
                    await settingViewModel.UpdateComment(intraId: homeViewModel.intraId)
                    homeViewModel.myInfo.comment = settingViewModel.newStatusMessage
                }
                .zIndex(1)
            }
            
            if settingViewModel.isCustomLocationAlertPresent {
                CustomAlert(title: "수동 자리 설정", textFieldTitle: "설정할 자리를 입력해주세요", inputText: $settingViewModel.inputText) {
                    withAnimation {
                        settingViewModel.isCustomLocationAlertPresent.toggle()
                        settingViewModel.inputText = ""
                    }
                } rightButtonAction: {
                    if await settingViewModel.UpdateCustomLocation(intraId: homeViewModel.intraId) {
                        withAnimation {
                            settingViewModel.isCustomLocationAlertPresent.toggle()
                        }
                        homeViewModel.myInfo.location = settingViewModel.newLocation
                    }
                }
                .zIndex(1)
            }
        }
        .zIndex(0)
    }
}

struct setButton: PrimitiveButtonStyle {
    var labelColor = Color.white
    var BackGroundColor = Color.whereDeepNavy

    func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .font(.GmarketLight34)
            .foregroundStyle(labelColor)
            .padding(.vertical)
            .frame(width: 200)
            .background(Capsule().fill(BackGroundColor))
    }
}

#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
}
