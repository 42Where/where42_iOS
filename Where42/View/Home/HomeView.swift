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
                Button("access token") {
                    API.sharedAPI.accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVc2VyIiwiaW50cmFJZCI6OTk3NjAsImludHJhTmFtZSI6ImRoeXVuIiwicm9sZXMiOiJDYWRldCIsImlhdCI6MTcwNjEwMTExNiwiaXNzIjoid2hlcmU0MiIsImV4cCI6MTcwNjEwNDcxNn0.1VmKO3KZ5Eze6bKK5S4Rd23HxWYOCu2tJDjCFRS1D6c"
                }
                Button("refresh token") {
                    API.sharedAPI.refreshToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVc2VyIiwiaW50cmFJZCI6OTk3NjAsImludHJhTmFtZSI6ImRoeXVuIiwicm9sZXMiOiJDYWRldCIsImlhdCI6MTcwNjEwMTExNiwiaXNzIjoid2hlcmU0MiIsImV4cCI6MTcwNjEwNDcxNn0.1VmKO3KZ5Eze6bKK5S4Rd23HxWYOCu2tJDjCFRS1D6c"
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
                        await homeViewModel.getMemberInfo()
                        await homeViewModel.getGroup()
                        if mainViewModel.isLogin == true {
                            homeViewModel.isAPILoaded = true
                        }
                        homeViewModel.countAllMembers()
                        homeViewModel.isLoading = false
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
