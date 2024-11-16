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
    @EnvironmentObject private var searchViewModel: SearchViewModel

    @Binding var memberInfo: MemberInfo

    @State private var isShowModal = false
    @State private var modalHeight: CGFloat = 0

    var body: some View {
        Button {
            if memberInfo.intraId != homeViewModel.myInfo.intraId &&
                homeViewModel.friends.members.contains(where: { $0.intraId == memberInfo.intraId }) == false
            {
                memberInfo.isCheck.toggle()
                withAnimation {
                    if memberInfo.isCheck {
                        searchViewModel.selectedMembers.insert(memberInfo, at: 0)
                    } else {
                        if let index = searchViewModel.selectedMembers.firstIndex(
                            where: { $0.intraId == memberInfo.intraId })
                        {
                            _ = searchViewModel.selectedMembers.remove(at: index)
                        }
                    }
                }
            } else {
                isShowModal = true
            }
            hideKeyboard()
        } label: {
            HStack(spacing: 10) {
                KFImage(URL(string: memberInfo.image)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .clipShape(Circle())
                    .scaledToFill()
                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: memberInfo.inCluster == true ? 3 : 0))
                    .overlay(Circle().stroke(.black, lineWidth: memberInfo.inCluster == false ? 0.1 : 0))
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(memberInfo.intraName)
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

                    Text(memberInfo.comment)
                        .font(.custom(Font.GmarketMedium, size: 14))
                        .foregroundStyle(.whereMediumNavy)
                        .lineLimit(2)
                }

                Spacer()

                if !homeViewModel.friends.members.contains(where: { $0.intraId == memberInfo.intraId }) {
                    if homeViewModel.myInfo.intraId == memberInfo.intraId {
                        EmptyView()
                    } else if searchViewModel.selectedMembers.count == 0 && !memberInfo.isCheck {
                        Image("Add Friend icon")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else if searchViewModel.selectedMembers.count > 0 && !memberInfo.isCheck {
                        Image("Empty Box")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else if searchViewModel.selectedMembers.count > 0 {
                        Image("Checked Box")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Image("Function icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .unredacted()
                }
            }
            .padding(.vertical, 1)
            .background()
        }
        .sheetOrPopOver(isPresented: $isShowModal) {
            FriendEditModal(
                memberInfo: $memberInfo,
                groupInfo: $homeViewModel.friends,
                isPresented: $isShowModal)
                .readSize()
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    if let size {
                        self.modalHeight = size.height
                    }
                }
                .presentationDetents([.height(modalHeight)])
        }
    }
}

#Preview {
    SearchMemberInfoView(memberInfo: .constant(MemberInfo(id: UUID(), intraId: 0, intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")))
        .environmentObject(HomeViewModel())
}
