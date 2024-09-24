//
//  HomeView.swift
//  Where42
//
//  Created by 현동호 on 10/28/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    @State private var showUpdateAlert = false

    var body: some View {
        ZStack {
            VStack {
                HomeInfoView(
                    memberInfo: $homeViewModel.myInfo,
                    isWork: $homeViewModel.isWorkCheked,
                    isNewGroupAlertPrsented: $mainViewModel.isNewGroupAlertPrsented
                )

                Divider()

                ScrollView {
                    HomeGroupView(groups: $homeViewModel.myGroups)

                    Spacer()
                }
                .refreshable {
                    Task {
                        await homeViewModel.getMemberInfo()
                        await homeViewModel.getGroup()
                    }
                }
            }
            .redacted(reason: homeViewModel.isLoading ? .placeholder : [])
            .disabled(homeViewModel.isLoading)

            .task {
                if mainViewModel.isLogin {
                    if !homeViewModel.isAPILoaded {
                        if await homeViewModel.reissue() {
                            await homeViewModel.getMemberInfo()
                            await homeViewModel.getGroup()
                            if mainViewModel.isLogin == true {
                                homeViewModel.isAPILoaded = true
                            }
                            homeViewModel.isLoading = false
                        }
                    }
                    
                    await mainViewModel.checkVersion()
                    if mainViewModel.isUpdateNeeded {
                        self.showUpdateAlert = true
                    }
                }
            }

            if homeViewModel.isLoading {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(.circular)
            }
        }
        .sheet(isPresented: $homeViewModel.isGroupMemberDeleteViewPrsented) {
            GroupMemberDeleteView(
                group: $homeViewModel.selectedGroup,
                isGroupEditModalPresented: $homeViewModel.isGroupEditSelectAlertPrsented
            )
        }
        .sheet(isPresented: $homeViewModel.isGroupMemberAddViewPrsented) {
            GroupMemberAddView(
                group: $homeViewModel.notInGroup,
                isGroupEditModalPresented: $homeViewModel.isGroupEditSelectAlertPrsented
            )
        }
        .fullScreenCover(isPresented: $mainViewModel.isSelectViewPrsented) {
            SelectingView()
        }
        .alert("새로운 버전이 출시되었습니다. 업데이트를 위해 이동합니다.", isPresented: $showUpdateAlert) {
            Button("예") {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/6478480891"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                KeychainManager.deleteToken(key: "accessToken")
                KeychainManager.deleteToken(key: "refreshToken")
                mainViewModel.isLogin = false
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel.shared)
        .environmentObject(HomeViewModel())
}
