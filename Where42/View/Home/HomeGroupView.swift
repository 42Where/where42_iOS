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
        LazyVStack(pinnedViews: .sectionHeaders) {
            ForEach(homeViewModel.isWorkCheked ? $homeViewModel.filteredGroups : $groups, id: \.id) { $group in
                if group.groupName != "default" {
                    HomeGroupSingleView(group: $group)

                    Divider()
                }
            }

            .background(.white)
            .environmentObject(homeGroupViewModel)

            HomeFriendView(friends: homeViewModel.isWorkCheked ? $homeViewModel.filteredFriends : $homeViewModel.friends)
        }
    }
}

#Preview {
    HomeGroupView(groups: .constant(HomeViewModel().myGroups))
        .environmentObject(HomeViewModel())
        .environmentObject(HomeGroupViewModel())
}
