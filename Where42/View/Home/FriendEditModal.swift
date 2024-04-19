//
//  FriendEditModal.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Kingfisher
import SwiftUI

struct FriendEditModal: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var memberInfo: MemberInfo
    @Binding var groupInfo: GroupInfo
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                KFImage(URL(string: memberInfo.image!)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: memberInfo.inCluster == true ? 3 : 0))
                    .overlay(Circle().stroke(.black, lineWidth: memberInfo.inCluster == false ? 0.1 : 0))
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(memberInfo.intraName!)
                            .font(.custom(Font.GmarketBold, size: 20))
                            .foregroundStyle(.whereDeepNavy)

                        Text(memberInfo.location!)
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .padding(5.0)
                            .padding(.horizontal, 2.0)
                            .background(memberInfo.inCluster == false ? .white : .whereDeepNavy)
                            .clipShape(Capsule())
                            .overlay(memberInfo.inCluster == false ? Capsule().stroke(.whereDeepNavy, lineWidth: 1) : Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                            .foregroundStyle(memberInfo.inCluster == false ? .whereDeepNavy : .white)
                    }

                    Text(memberInfo.comment!)
                        .font(.custom(Font.GmarketMedium, size: 16))
                        .foregroundStyle(.whereMediumNavy)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding([.top, .leading])

            Button {
                if memberInfo.intraId != homeViewModel.myInfo.intraId {
                    withAnimation {
                        isPresented = false
                        homeViewModel.isFriendDeleteAlertPresented = true
                        homeViewModel.selectedMember = memberInfo
                        homeViewModel.selectedGroup = groupInfo
                    }
                }
            } label: {
                if homeViewModel.isFriend {
                    Text("친구 삭제하기")
                        .foregroundStyle(memberInfo.intraId == homeViewModel.myInfo.intraId ? .gray : .red)
                        .font(.custom(Font.GmarketMedium, size: 16))
                } else {
                    Text("그룹에서 삭제하기")
                        .foregroundStyle(.red)
                        .font(.custom(Font.GmarketMedium, size: 16))
                }
            }
            .padding()
        }
        .onAppear {
            print(memberInfo.id)
            if groupInfo.groupId == homeViewModel.friends.groupId {
                homeViewModel.isFriend = true
            } else {
                homeViewModel.isFriend = false
            }
        }
    }
}

#Preview {
    FriendEditModal(memberInfo: .constant(MemberInfo(id: UUID(), intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")), groupInfo: .constant(HomeViewModel().friends), isPresented: .constant(true))
        .environmentObject(HomeViewModel())
}
