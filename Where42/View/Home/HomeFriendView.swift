//
//  HomeFriendView.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct HomeFriendView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @Binding var friends: GroupInfo

    @State private var modalHeight: CGFloat = 0
    @State private var isSheetPresent: Bool = false

    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                if friends.isOpen! && friends.totalNum! > 0 {
                    ForEach($friends.members, id: \.self) { $user in
                        if !(homeViewModel.isWork && user.location == "퇴근") {
                            HomeFriendInfoView(userInfo: $user, groupInfo: $friends)
                                .padding(.horizontal)
                                .padding(.vertical, 1)
                        }
                    }
                }
            } header: {
                VStack {
                    HStack {
                        Text("\(friends.groupName)")
                            .font(.custom(Font.GmarketMedium, size: 13))
                        Text("\(friends.onlineNum!)/\(friends.totalNum!)")
                            .font(.custom(Font.GmarketMedium, size: 11))

                        Spacer()

                        HStack {
                            Button {} label: {
                                Image("Filter icon")
                            }

                            Button {
                                isSheetPresent.toggle()
                            } label: {
                                Image("Edit icon")
                            }

                            Button {
                                withAnimation {
                                    friends.isOpen!.toggle()
                                }
                            } label: {
                                if friends.isOpen! {
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
                    if friends.isOpen! && friends.totalNum! > 0 {
                        Divider()
                    }
                }
                .background(.white)
            }

            .sheet(isPresented: $isSheetPresent) {
                GroupEditModal(group: $homeViewModel.friends, isPresented: $isSheetPresent)
                    .readSize()
                    .onPreferenceChange(SizePreferenceKey.self, perform: { value in
                        if let value {
                            modalHeight = value.height
                        }
                    })
                    .presentationDetents([.height(modalHeight)])
            }

            Divider()
        }
    }
}

#Preview {
    HomeFriendView(friends: .constant(HomeViewModel().friends))
        .environmentObject(HomeViewModel())
}
