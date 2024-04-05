//
//  Setting.swift
//  Where42
//
//  Created by 현동호 on 10/29/23.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel

    var body: some View {
        ZStack {
            VStack {
                Text("환경설정")
                    .font(.GmarketBold34)

                Spacer()

                Button("로그아웃") {
                    withAnimation {
                        settingViewModel.isLogoutAlertPresented = true
                    }
                }
                .buttonStyle(setButton())

                Spacer()
                    .frame(height: 70)

                Button("코멘트 설정") {
                    withAnimation {
                        settingViewModel.isCommentAlertPresented = true
                        settingViewModel.inputText = homeViewModel.myInfo.comment ?? ""
                    }
                }
                .buttonStyle(setButton())

                Spacer()
                    .frame(height: 70)

                Button("자리 설정") {
                    if homeViewModel.myInfo.inCluster == true {
                        withAnimation {
                            settingViewModel.isCustomLocationAlertPresented = true
                        }
                    } else {
                        mainViewModel.toast = Toast(title: "자리 설정은 클러스터 안에서만 할 수 있습니다")
                    }
                }
                .buttonStyle(setButton())

                Spacer()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)

            SettingAlert()
                .zIndex(1)

            if mainViewModel.is42IntraSheetPresented {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(.circular)
                    .zIndex(2)
            }
        }
        .zIndex(0)
        .environmentObject(settingViewModel)
//        .navigationBarBackButtonHidden()
        .disabled(mainViewModel.is42IntraSheetPresented)
    }
}

struct setButton: PrimitiveButtonStyle {
    var labelColor = Color.white
    var BackGroundColor = Color.whereDeepNavy

    func makeBody(configuration: Configuration) -> some View {
        Button(configuration)
            .font(.GmarketLight34)
//            .font(.custom(Font.GmarketLight, size: 20))
            .foregroundStyle(labelColor)
            .padding(.vertical)
            .frame(width: 200)
//            .frame(width: 140)
            .background(Capsule().fill(BackGroundColor))
    }
}

#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(HomeViewModel())
}
