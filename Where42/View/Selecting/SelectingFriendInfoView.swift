//
//  SelectingFriendInfoView.swift
//  Where42
//
//  Created by 현동호 on 11/14/23.
//

import Kingfisher
import SwiftUI

struct SelectingFriendInfoView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var memberInfo: MemberInfo

    var body: some View {
        Button {
            memberInfo.isCheck.toggle()

            if memberInfo.isCheck {
                homeViewModel.selectedMembers.append(memberInfo)
            } else {
                if let index = homeViewModel.selectedMembers.firstIndex(
                    where: { $0.intraId == memberInfo.intraId })
                {
                    homeViewModel.selectedMembers.remove(at: index)
                }
            }
        } label: {
            HStack(spacing: 10) {
                KFImage(URL(string: memberInfo.image!)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: memberInfo.inCluster == true ? 3 : 0))
                    .overlay(Circle().stroke(.black, lineWidth: memberInfo.inCluster == false ? 0.1 : 0))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(memberInfo.intraName!)
                            .font(.custom(Font.GmarketBold, size: 16))
                            .foregroundStyle(.whereDeepNavy)

                        HStack(spacing: 4) {
                            Text(memberInfo.location!)
                        }
                        .font(.custom(Font.GmarketMedium, size: 13))
                        .padding(5.0)
                        .padding(.horizontal, 2.0)
                        .background(memberInfo.inCluster == false ? .white : .whereDeepNavy)
                        .clipShape(Capsule())
                        .overlay(memberInfo.inCluster == false ? Capsule().stroke(.whereDeepNavy, lineWidth: 1) : Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                        .foregroundStyle(memberInfo.inCluster == false ? .whereDeepNavy : .white)
                    }

                    Text(memberInfo.comment!)
                        .font(.custom(Font.GmarketMedium, size: 14))
                        .foregroundStyle(.whereMediumNavy)
                        .lineLimit(1)
                }

                Spacer()

                if memberInfo.isCheck {
                    Image("Checked Box")
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image("Empty Box")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.vertical, 1)
            .background()
        }
//        .onDisappear {
//            memberInfo.isCheck = false
//        }
    }
}

#Preview {
    SelectingFriendInfoView(memberInfo: .constant(MemberInfo(id: UUID(), intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")))
        .environmentObject(HomeViewModel())
}
