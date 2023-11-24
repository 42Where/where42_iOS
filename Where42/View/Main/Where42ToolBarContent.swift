//
//  ToolBarView.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

struct Where42ToolBarContent: ToolbarContent {
    @EnvironmentObject var mainViewModel: MainViewModel

    @Binding var isShowSheet: Bool
    var isSettingPresenting: Bool

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                mainViewModel.tabSelection = "Home"
            } label: {
                Image("Where42 logo 3")
            }
        }

        if isSettingPresenting {
            ToolbarItem(placement: .topBarTrailing) {
                Button { isShowSheet.toggle() } label: { Image("Setting icon M") }
                    .sheet(isPresented: $isShowSheet) {
                        SettingView()
                    }
                //                        NavigationLink(destination: SettingView(), label: { Image("Setting icon M") })
            }
        }
    }
}
