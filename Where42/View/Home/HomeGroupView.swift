//
//  HomeGroupView.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct HomeGroupView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @StateObject var homeGroupViewModel: HomeGruopViewModel = .init()
    @Binding var groups: [GroupInfo]

    var body: some View {
        VStack {
            ForEach($groups, id: \.self) { $group in
                if group.groupName != "default" {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        Section {
                            if group.isOpen! && group.totalNum! > 0 {
                                ForEach($group.members, id: \.self) { $user in
                                    if !(homeViewModel.isWork && user.location == "퇴근") {
                                        HomeFriendInfoView(userInfo: $user, groupInfo: $group)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)
                                    }
                                }
                            }
                        } header: {
                            VStack {
                                HStack {
                                    Text("\(group.groupName)")
                                        .font(.custom(Font.GmarketMedium, size: 13))
                                    Text("\(group.onlineNum!)/\(group.totalNum!)")
                                        .font(.custom(Font.GmarketMedium, size: 11))

                                    Spacer()

                                    HStack {
                                        Button {} label: {
                                            Image("Filter icon")
                                        }

                                        Button {
                                            homeGroupViewModel.isEditModalSheetPresent.toggle()
                                            homeViewModel.selectedGroup = group
                                        } label: {
                                            Image("Edit icon")
                                        }

                                        Button {
                                            withAnimation {
                                                group.isOpen!.toggle()
                                            }
                                        } label: {
                                            if group.isOpen! {
                                                Image("Fold icon")
                                            } else {
                                                Image("Folded icon")
                                            }
                                        }
                                    }
                                    .unredacted()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 3)

                                if group.isOpen! && group.totalNum! > 0 {
                                    Divider()
                                }
                            }
                            .background(.white)
                        }
                    }

                    Divider()
                }
            }
            .sheet(isPresented: $homeGroupViewModel.isEditModalSheetPresent) {
                ZStack {
                    GroupEditModal(group: $homeViewModel.selectedGroup, isPresented: $homeGroupViewModel.isEditModalSheetPresent)
                        .readSize()
                        .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                            if let value {
                                homeGroupViewModel.modalHeight = value.height
                            }
                        })
                        .presentationDetents([.height(homeGroupViewModel.modalHeight)])
                }
            }
        }
        .background(.white)

        HomeFriendView(friends: $homeViewModel.friends)
    }
}

#Preview {
    HomeGroupView(groups: .constant(HomeViewModel().groups))
        .environmentObject(HomeViewModel())
}
