//
//  InfoView.swift
//  Where42
//
//  Created by 현동호 on 3/4/24.
//

import SwiftUI

struct MembersView: View {
    @Binding var members: [MemberInfo]
    @State var isSearch: Bool

    var body: some View {
        if isSearch {
            ForEach(0 ..< members.count, id: \.self) { index in
                if searchViewModel.name == "" ||
                    (members[index].intraName?.contains(searchViewModel.name.lowercased())) == true
                {
                    if UIDevice.idiom == .phone {
                        SearchMemberInfoView(memberInfo: $members[index])
                            .padding(index == 0 && homeViewModel.selectedMembers.count != 0 ? [] : .top)
                    } else if UIDevice.idiom == .pad {
                        if index % 2 == 0 {
                            HStack {
                                SearchMemberInfoView(memberInfo: $members[index])
                                    .padding([index == 0 && homeViewModel.selectedMembers.count != 0 ? [] : .top, .horizontal])
                                if index + 1 < members.count {
                                    SearchMemberInfoView(memberInfo: $members[index + 1])
                                        .padding([index == 0 && homeViewModel.selectedMembers.count != 0 ? [] : .top, .horizontal])
                                } else {
                                    Spacer()
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
        } else {
            ForEach(0 ..< group.members.count, id: \.self) { index in
                if !(homeViewModel.isWorkCheked && group.members[index].inCluster == false) {
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
    }
}
