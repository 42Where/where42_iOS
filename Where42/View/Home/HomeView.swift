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

    var body: some View {
        ZStack {
            VStack {
                Button("expires") {
                    KeychainManager.updateToken(key: "accessToken", token: "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVc2VyIiwiaW50cmFJZCI6OTk3NjAsImludHJhTmFtZSI6ImRoeXVuIiwidHlwZSI6ImFjY2Vzc1Rva2VuIiwicm9sZXMiOiJDYWRldCIsImlhdCI6MTcxMzQ0NzEwNCwiaXNzIjoid2hlcmU0MiIsImV4cCI6MTcxMzQ1MDcwNH0.JAgxCqm713yRMaYg-6v7GCMeYOWFazR8d3BeUQrw-bU")
                    print(KeychainManager.readToken(key: "accessToken") as Any)
                }
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
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel.shared)
        .environmentObject(HomeViewModel())
}
