//
//  GroupEditModal.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct GroupEditModal: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var mainViewModel: MainViewModel

    @Binding var group: GroupInfo
    @Binding var isPresented: Bool

    let GmarketFont: GmarketSansTTF = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(group.groupName)")
                    .font(.custom(Font.GmarketMedium, size: 16))

                Text("\(group.onlineNum!)/\(group.totalNum!)")
                    .font(.custom(Font.GmarketMedium, size: 13))

                Spacer()
            }
            .foregroundStyle(.whereDeepNavy)

            Divider()

            VStack(alignment: .leading, spacing: 40) {
                Button {
                    withAnimation {
                        isPresented.toggle()
                        homeViewModel.selectedGroup = group
                        mainViewModel.isEditGroupNameAlertPrsented.toggle()
                    }
                } label: {
                    Text("그룹 이름 수정하기")
                        .foregroundStyle(.whereMediumNavy)
                }

                Button {} label: {
                    Text("그룹 수정하기")
                        .foregroundStyle(.whereMediumNavy)
                }

                Button {
                    isPresented.toggle()
                    homeViewModel.selectedGroup = group
                    mainViewModel.isDeleteGroupAlertPrsented.toggle()
                } label: {
                    Text("그룹 삭제하기")
                        .foregroundStyle(.red)
                }
            }
            .font(.custom(Font.GmarketMedium, size: 16))
            .padding(.vertical, 20)
        }
        .padding()
    }
}

#Preview {
    GroupEditModal(group: .constant(HomeViewModel().friends), isPresented: .constant(false))
        .environmentObject(HomeViewModel())
}
