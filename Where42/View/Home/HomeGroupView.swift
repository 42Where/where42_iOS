//
//  HomeGroupView.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct HomeGroupView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject var homeGroupViewModel: HomeGroupViewModel = .init()
    @Binding var groups: [GroupInfo]

    var body: some View {
        VStack {
            ForEach($groups) { $group in
                if group.groupName != "default" {
                    HomeGroupSingleView(group: $group)

                    Divider()
                }
            }
        }

        .background(.white)
        .environmentObject(homeGroupViewModel)

        HomeFriendView(friends: $homeViewModel.friends)
    }
}

#Preview {
    HomeGroupView(groups: .constant(HomeViewModel().myGroups))
        .environmentObject(HomeViewModel())
        .environmentObject(HomeGroupViewModel())
}
