//
//  ToolBarView.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

struct Where42ToolBarContent: ToolbarContent {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    //    @Binding var isShowSheet: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                mainViewModel.tabSelection = "Home"
                mainViewModel.isSelectViewPrsented = false
                homeViewModel.inputText = ""
            } label: {
                Image("Where42 logo 3")
            }
            .disabled(mainViewModel.isDeleteGroupAlertPrsented ||
                      mainViewModel.isNewGroupAlertPrsented ||
                      mainViewModel.isEditGroupNameAlertPrsented ||
                      homeViewModel.isGroupEditSelectAlertPrsented ||
                      homeViewModel.isFriendDeleteAlertPresented ||
                      settingViewModel.isCustomLocationAlertPresentedInHome ||
                      !networkMonitor.isConnected)
        }
        
        if mainViewModel.tabSelection == "Home" {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(
                    destination: AnnouncementView(),
                    label: { Image("Announcement icon M") }
                )
                .disabled(mainViewModel.isDeleteGroupAlertPrsented ||
                          mainViewModel.isNewGroupAlertPrsented ||
                          mainViewModel.isEditGroupNameAlertPrsented ||
                          homeViewModel.isGroupEditSelectAlertPrsented ||
                          homeViewModel.isFriendDeleteAlertPresented ||
                          settingViewModel.isCustomLocationAlertPresentedInHome ||
                          homeViewModel.isLoading ||
                          !networkMonitor.isConnected)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(
                    destination: ClustersView(),
                    label: { Image("Clusters icon") }
                )
                .disabled(mainViewModel.isDeleteGroupAlertPrsented ||
                          mainViewModel.isNewGroupAlertPrsented ||
                          mainViewModel.isEditGroupNameAlertPrsented ||
                          homeViewModel.isGroupEditSelectAlertPrsented ||
                          homeViewModel.isFriendDeleteAlertPresented ||
                          settingViewModel.isCustomLocationAlertPresentedInHome ||
                          homeViewModel.isLoading ||
                          !networkMonitor.isConnected)
            }
            ToolbarItem(placement: .topBarTrailing) {
                //                Button { isShowSheet.toggle() } label: { Image("Setting icon M") }
                //                    .sheet(isPresented: $isShowSheet) {
                //                        SettingView()
                //                    }
                NavigationLink(
                    destination: SettingView(),
                    label: { Image("Setting icon M") }
                )
                .disabled(mainViewModel.isDeleteGroupAlertPrsented ||
                          mainViewModel.isNewGroupAlertPrsented ||
                          mainViewModel.isEditGroupNameAlertPrsented ||
                          homeViewModel.isGroupEditSelectAlertPrsented ||
                          homeViewModel.isFriendDeleteAlertPresented ||
                          settingViewModel.isCustomLocationAlertPresentedInHome ||
                          homeViewModel.isLoading ||
                          !networkMonitor.isConnected)
            }
        }
    }
}
