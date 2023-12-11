//
//  HomeFriendInfoView.swift
//  Where42
//
//  Created by 현동호 on 11/7/23.
//

import Kingfisher
import SwiftUI

struct HomeFriendInfoView: View {
    @Binding var userInfo: MemberInfo
    @Binding var groupInfo: GroupInfo

    @State private var isWork = false
    @State private var isShowModal: Bool = false
    @State private var modalheight: CGFloat = 0

    var body: some View {
        Button {
            isShowModal.toggle()
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

                Button {
                    isShowModal.toggle()
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

        .sheet(isPresented: $isShowModal) {
            FriendEditModal(userInfo: $userInfo, groupInfo: $groupInfo, isFriend: .constant(true), isPresented: $isShowModal)
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

struct ModalSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .opacity(configuration.isPressed ? 0.30 : 1)
    }
}

#Preview {
    HomeFriendInfoView(userInfo: .constant(MemberInfo(intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")), groupInfo: .constant(HomeViewModel().friends))
        .environmentObject(HomeViewModel())
}
