//
//  GroupEditView.swift
//  Where42
//
//  Created by 현동호 on 12/23/23.
//

import SwiftUI

struct GroupEditView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var group: GroupInfo

    @State private var isShowSheet = false

    var body: some View {
        VStack {
            Text("\(group.groupName)")
                .font(.custom(Font.GmarketBold, size: 25))
                .padding(.top, 40)

            VStack {
                ForEach($group.members, id: \.self) { $user in
                    SelectingFriendInfoView(userInfo: $user)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()

            HStack {
                Spacer()

                Button {
                    Task {
                        await homeViewModel.deleteUserInGroup()
                        homeViewModel.isGroupEditViewPrsented = false
                    }
                } label: {
                    Text("그룹에서 삭제")
                        .font(.custom(Font.GmarketMedium, size: 20))
                        .foregroundStyle(.white)
                }
                .clipShape(Rectangle())
                .padding()

                Spacer()
            }
            .background(.whereRed)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    GroupEditView(group: .constant(GroupInfo(id: UUID(), groupId: 0, groupName: "테스트 그룹", totalNum: 10, onlineNum: 10, isOpen: true, members: [
        .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6")
    ])))
    .environmentObject(HomeViewModel())
}
