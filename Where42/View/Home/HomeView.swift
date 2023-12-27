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
        NavigationView {
            ZStack {
                VStack {
                    HomeInfoView(memberInfo: $homeViewModel.myInfo,
                                 isWork: $homeViewModel.isWork,
                                 isNewGroupAlertPrsent: $mainViewModel.isNewGroupAlertPrsented)
                        
                    Divider()
                    
                    ScrollView {
                        HomeGroupView(groups: $homeViewModel.groups)
                            
                        Spacer()
                        
                            .toolbar {
                                Where42ToolBarContent(isShowSheet: $homeViewModel.isShowSettingSheet, isSettingPresenting: true)
                            }
                            .unredacted()
                    }
                    .refreshable {
                        homeViewModel.getGroup()
                    }
                }
                .redacted(reason: homeViewModel.isLoading ? .placeholder : [])
                .disabled(homeViewModel.isLoading)
                
                .onAppear {
                    homeViewModel.countOnlineUsers()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        homeViewModel.isLoading = false
                    }
                }
                .task {
                    if !homeViewModel.isAPILoaded {
                        homeViewModel.getMemberInfo()
                        homeViewModel.getGroup()
                        homeViewModel.isAPILoaded = true
                    }
                }
                
                if homeViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(.circular)
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MainViewModel())
        .environmentObject(HomeViewModel())
}
