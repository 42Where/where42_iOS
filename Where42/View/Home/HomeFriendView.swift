//
//  HomeFriendView.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct HomeFriendView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var friends: GroupInfo

    @State private var modalHeight: CGFloat = 0
    @State private var isSheetPresent: Bool = false

    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if friends.isOpen && friends.totalNum >= 0 {
                    if friends.totalNum == 0 || (homeViewModel.isWorkCheked && friends.onlineNum == 0) {
                        Text("아무도 없어요...")
                            .font(.custom(Font.GmarketMedium, size: 18))
                            .foregroundStyle(.whereDeepNavy)
                            .padding()
                    } else {
                        ForEach(Array(zip(
                            0 ..< friends.members.count,
                            $friends.members)), id: \.0)
                        { index, $member in

                            if UIDevice.idiom == .phone {
                                HomeFriendInfoView(
                                    memberInfo: $member,
                                    groupInfo: $friends)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)

                            } else if UIDevice.idiom == .pad {
                                if index % 2 == 0 {
                                    HStack {
                                        HomeFriendInfoView(
                                            memberInfo: $member,
                                            groupInfo: $friends)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)

                                        if index + 1 < friends.members.count {
                                            HomeFriendInfoView(
                                                memberInfo: $friends.members[index + 1],
                                                groupInfo: $friends)
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
                        Text(friends.groupName)
                            .font(.custom(Font.GmarketMedium, size: 13))
                            .lineLimit(1)
                        Text("\(friends.onlineNum)/\(friends.totalNum)")
                            .font(.custom(Font.GmarketMedium, size: 11))

                        Spacer()

                        HStack {
                            Button {
                                homeViewModel.selectedGroup = friends
                                isSheetPresent.toggle()
                            } label: {
                                Image("Edit icon")
                            }

                            Button {
                                withAnimation {
                                    friends.isOpen.toggle()
                                }
                            } label: {
                                if friends.isOpen {
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

                    if friends.isOpen && friends.totalNum > 0 {
                        Divider()
                    }
                }
                .background(.white)
                .sheetOrPopOver(isPresented: $isSheetPresent) {
                    GroupEditModal(
                        group: $homeViewModel.friends,
                        isPresented: $isSheetPresent)
                        .readSize()
                        .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                            if let value {
                                modalHeight = value.height
                            }
                        })
                        .presentationDetents([.height(modalHeight)])
                }
            }

            Divider()
        }
    }
}

#Preview {
    HomeFriendView(friends: .constant(HomeViewModel().friends))
        .environmentObject(HomeViewModel())
}
