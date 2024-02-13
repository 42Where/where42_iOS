//
//  SearchMemberInfoView.swift
//  Where42
//
//  Created by 현동호 on 1/26/24.
//

import Kingfisher
import SwiftUI

struct SearchMemberInfoView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var userInfo: MemberInfo

    @State private var isCheck = false

    var body: some View {
        Button {
            userInfo.isCheck.toggle()
            isCheck.toggle()
            if isCheck {
                withAnimation {
                    homeViewModel.selectedMembers.append(userInfo)
                }
            } else {
                if let index = homeViewModel.selectedMembers.firstIndex(
                    where: { $0.intraId == userInfo.intraId })
                {
                    withAnimation {
                        homeViewModel.selectedMembers.remove(at: index)
                    }
                }
            }
        } label: {
            HStack(spacing: 10) {
                KFImage(URL(string: userInfo.image!)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: userInfo.location != "퇴근" ? 3 : 0))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(userInfo.intraName!)
                            .font(.custom(Font.GmarketBold, size: 16))
                            .foregroundStyle(.whereDeepNavy)

                        HStack(spacing: 4) {
                            Text(userInfo.location!)
                        }
                        .font(.custom(Font.GmarketMedium, size: 13))
                        .padding(5.0)
                        .padding(.horizontal, 2.0)
                        .background(userInfo.location == "퇴근" ? .white : .whereDeepNavy)
                        .clipShape(Capsule())
                        .overlay(userInfo.location == "퇴근" ? Capsule().stroke(.whereDeepNavy, lineWidth: 1) : Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                        .foregroundStyle(userInfo.location == "퇴근" ? .whereDeepNavy : .white)
                    }

                    Text(userInfo.comment!)
                        .font(.custom(Font.GmarketMedium, size: 14))
                        .foregroundStyle(.whereMediumNavy)
                }

                Spacer()

//                if !homeViewModel.friends.members.contains(where: { $0.intraId == userInfo.intraId }) {
                if homeViewModel.selectedMembers.count == 0 && !isCheck {
                    Image("Add Friend icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                } else if homeViewModel.selectedMembers.count > 0 && !isCheck {
                    Image("Empty Box")
                        .resizable()
                        .frame(width: 20, height: 20)
                } else if homeViewModel.selectedMembers.count > 0 {
                    Image("Checked Box")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
//                }
            }
            .padding(.vertical, 1)
            .background()
        }
        .onAppear {
            userInfo.isCheck = isCheck

            if isCheck &&
                !homeViewModel.selectedMembers.contains(where: { $0.intraId == userInfo.intraId })
            {
                homeViewModel.selectedMembers.append(userInfo)
            }
        }
//        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    SearchMemberInfoView(userInfo: .constant(MemberInfo(intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")))
        .environmentObject(HomeViewModel())
}
