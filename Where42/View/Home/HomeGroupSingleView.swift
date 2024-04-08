//
//  groupBar.swift
//  Where42
//
//  Created by 현동호 on 1/8/24.
//

import SwiftUI

struct HomeGroupSingleView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var homeGroupViewModel: HomeGroupViewModel

    @Binding var group: GroupInfo

    @State var isPresented = false
    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if group.isOpen && group.totalNum >= 0 {
                    if group.totalNum == 0 || (homeViewModel.isWorkCheked && group.onlineNum == 0) {
                        Text("아무도 없어요...")
                            .font(.custom(Font.GmarketMedium, size: 18))
                            .foregroundStyle(.whereDeepNavy)
                            .padding()
                    } else {
                        ForEach(0 ..< group.members.count, id: \.self) { index in

                            if UIDevice.idiom == .phone {
                                HomeFriendInfoView(memberInfo: $group.members[index], groupInfo: $group)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                            } else if UIDevice.idiom == .pad {
                                if index % 2 == 0 {
                                    HStack {
                                        HomeFriendInfoView(memberInfo: $group.members[index], groupInfo: $group)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)
                                        if index + 1 < group.members.count {
                                            HomeFriendInfoView(memberInfo: $group.members[index + 1], groupInfo: $group)
                                                .padding(.horizontal)
                                                .padding(.vertical, 1)
                                        } else {
                                            Spacer()
                                                .padding()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } header: {
                VStack {
                    HStack {
                        Text(group.groupName)
                            .font(.custom(Font.GmarketMedium, size: 13))
                            .lineLimit(1)
                        Text("\(group.onlineNum)/\(group.totalNum)")
                            .font(.custom(Font.GmarketMedium, size: 11))

                        Spacer()

                        HStack {
                            Button {
                                isPresented.toggle()
                                homeViewModel.selectedGroup = group
                            } label: {
                                Image("Edit icon")
                            }

                            Button {
                                withAnimation {
                                    group.isOpen.toggle()
                                }
                                homeViewModel.setIsOpen(groupId: group.groupId!, isOpen: group.isOpen)
                            } label: {
                                if group.isOpen {
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
                    .background(.white)
                    .onTapGesture {
                        withAnimation {
                            group.isOpen.toggle()
                        }
                        homeViewModel.setIsOpen(groupId: group.groupId!, isOpen: group.isOpen)
                    }

                    if group.isOpen && group.totalNum >= 0 {
                        Divider()
                    }
                }
                .background(.white)
                .sheetOrPopOver(isPresented: $isPresented) {
                    GroupEditModal(
                        group: $homeViewModel.selectedGroup,
                        isPresented: $isPresented)
                        .readSize()
                        .onPreferenceChange(SizePreferenceKey.self, perform: { size in
                            if let size {
                                homeGroupViewModel.modalHeight = size.height
                            }
                        })
                        .presentationDetents([.height(homeGroupViewModel.modalHeight)])
                }
            }
        }
    }
}

#Preview {
    HomeGroupSingleView(group: .constant(.empty))
        .environmentObject(HomeViewModel())
        .environmentObject(HomeGroupViewModel())
}
