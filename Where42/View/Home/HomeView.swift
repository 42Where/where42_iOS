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
    @AppStorage("accessToken") var accessToken = ""
    
    var body: some View {
        ZStack {
            VStack {
                Button("토큰") {
                    accessToken = ""
                }
                
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
                    homeViewModel.getMemberInfo()
                    homeViewModel.getGroup()
                }
            }
            .redacted(reason: homeViewModel.isLoading ? .placeholder : [])
            .disabled(homeViewModel.isLoading)
                
            .onAppear {
                homeViewModel.countOnlineUsers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    homeViewModel.isLoading = false
                }
            }
            .task {
                if !homeViewModel.isAPILoaded {
                    homeViewModel.getMemberInfo()
                    homeViewModel.getGroup()
                    if isLogin == true {
                        homeViewModel.isAPILoaded = true
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
                group: $homeViewModel.notInGroups,
                isGroupEditModalPresented: $homeViewModel.isGroupEditSelectAlertPrsented
            )
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel())
        .environmentObject(HomeViewModel())
}
