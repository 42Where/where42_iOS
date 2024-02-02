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
    @AppStorage("accessToken") var accessToken = ""

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
                MyWebView(
                    urlToLoad: settingViewModel.intraURL,
                    isPresented: $settingViewModel.isIntraPresented)
                    .ignoresSafeArea()
            })

            SettingAlert()
                .zIndex(1)
        }
        .zIndex(0)
        .environmentObject(settingViewModel)
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
