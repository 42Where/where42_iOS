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
    @AppStorage("isLogin") var isLogin = false
    
    var body: some View {
        ZStack {
            VStack {
//                Button("access 초기화") {
//                    homeViewModel.resetAccesstoken()
//                }
//                Button("access 만료") {
//                    homeViewModel.expireAccesstoken()
//                }
//                Button("refresh 초기화") {
//                    homeViewModel.resetRefreshtoken()
//                }
//                Button("refresh 만료") {
//                    homeViewModel.expireRefreshtoken()
//                }
//                Button("toast") {
//                    mainViewModel.toast = Toast(title: "제가 보이시나요?")
//                }

                HomeInfoView(
                    memberInfo: $homeViewModel.myInfo,
                    isWork: $homeViewModel.isWork,
                    isNewGroupAlertPrsent: $mainViewModel.isNewGroupAlertPrsented
                )
                        
                Divider()
                    
                ScrollView {
                    HomeGroupView(groups: $homeViewModel.groups)
                            
                    Spacer()
                }
                .refreshable {
                    Task {
                        if await homeViewModel.reissue() {
                            homeViewModel.getMemberInfo()
                            homeViewModel.getGroup()
                        }
                    }
                }
            }
            .redacted(reason: homeViewModel.isLoading ? .placeholder : [])
            .disabled(homeViewModel.isLoading)
                
            .onAppear {
                if !homeViewModel.isAPILoaded {
                    homeViewModel.getMemberInfo()
                    homeViewModel.getGroup()
                    if isLogin == true {
                        homeViewModel.isAPILoaded = true
                    }
                }
                homeViewModel.countOnlineUsers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    homeViewModel.isLoading = false
                }
            }
            .task {
                _ = await homeViewModel.reissue()
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
                group: $homeViewModel.notInGroups,
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
