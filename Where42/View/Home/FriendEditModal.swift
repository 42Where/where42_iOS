//
//  FriendEditModal.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Kingfisher
import SwiftUI

struct FriendEditModal: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @Binding var userInfo: UserInfo
    @Binding var groupInfo: GroupInfo
    @Binding var isFriend: Bool
    @Binding var isPresented: Bool

    let GmarketFont: GmarketSansTTF = .init()

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                KFImage(URL(string: userInfo.avatar)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: userInfo.location != "퇴근" ? 3 : 0))
                    .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(userInfo.name)
                            .font(.custom(Font.GmarketBold, size: 20))
                            .foregroundStyle(.whereDeepNavy)

                        HStack(spacing: 4) {
                            Text(userInfo.location)
                        }
                        .font(.custom(Font.GmarketMedium, size: 15))
                        .padding(5.0)
                        .padding(.horizontal, 2.0)
                        .background(userInfo.location == "퇴근" ? .white : .whereDeepNavy)
                        .clipShape(Capsule())
                        .overlay(userInfo.location == "퇴근" ? Capsule().stroke(.whereDeepNavy, lineWidth: 1) : Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                        .foregroundStyle(userInfo.location == "퇴근" ? .whereDeepNavy : .white)
                    }

                    Text(userInfo.comment)
                        .font(.custom(Font.GmarketMedium, size: 16))
                        .foregroundStyle(.whereMediumNavy)
                }

                Spacer()

                Button {
                    //                isShowModal.toggle()
                } label: {
                    Image("Function icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .padding()
            }
            .padding([.top, .leading])

            Button {
                withAnimation {
                    if isFriend {
                        homeViewModel.deleteUser(group: &groupInfo, name: userInfo.name)
                    } else {
                        homeViewModel.addUser(group: &groupInfo, userInfo: userInfo)
                    }
                    isPresented.toggle()
                }
            } label: {
                if isFriend {
                    Text("친구 삭제하기")
                        .foregroundStyle(.red)
                        .font(.custom(Font.GmarketMedium, size: 16))
                } else {
                    Text("친구 추가하기")
                        .foregroundStyle(.whereDeepNavy)
                        .font(.custom(Font.GmarketMedium, size: 16))
                }
            }
            .padding()
        }
    }
}

#Preview {
    FriendEditModal(userInfo: .constant(UserInfo(name: "dhyun", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요")), groupInfo: .constant(HomeViewModel().friends), isFriend: .constant(true), isPresented: .constant(true))
        .environmentObject(HomeViewModel())
}
