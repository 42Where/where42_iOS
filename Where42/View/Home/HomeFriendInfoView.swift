//
//  HomeFriendInfoView.swift
//  Where42
//
//  Created by 현동호 on 11/7/23.
//

import Kingfisher
import SwiftUI

struct HomeFriendInfoView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @Binding var memberInfo: MemberInfo
    @Binding var groupInfo: GroupInfo

    @State private var isShowModal = false
    @State private var modalheight: CGFloat = 0

    var body: some View {
        Button {
            isShowModal.toggle()
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
                        .lineLimit(2)
                }

                Spacer()

                Button {
                    isShowModal = true
                } label: {
                    Image("Function icon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .unredacted()
            }
            .padding(.vertical, 1)
            .background()
        }
        .buttonStyle(ScaleButtonStyle())

        .sheetOrPopOver(isPresented: $isShowModal) {
            FriendEditModal(
                memberInfo: $memberInfo,
                groupInfo: $groupInfo,
                isPresented: $isShowModal)
                .readSize()
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    if let size {
                        self.modalheight = size.height
                    }
                }
                .presentationDetents([.height(modalheight)])
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .opacity(configuration.isPressed ? 0.30 : 1)
    }
}

#Preview {
    HomeFriendInfoView(memberInfo: .constant(MemberInfo(intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")), groupInfo: .constant(HomeViewModel().friends))
        .environmentObject(HomeViewModel())
}
