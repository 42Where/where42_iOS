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
                            
                        HomeFriendView(friends: $homeViewModel.friends)
                        
                        Spacer()
                        
                            .toolbar {
                                Where42ToolBarContent(isShowSheet: $homeViewModel.isShowSettingSheet, isSettingPresenting: true)
                            }
                    }
                    .refreshable {}
                }
                
                .onAppear {
                    homeViewModel.countOnlineUsers()
                }
                .task {
                    homeViewModel.getMemberInfo()
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
