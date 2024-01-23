//
//  GroupEditModal.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

struct GroupEditModal: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var mainViewModel: MainViewModel

    @Binding var group: GroupInfo
    @Binding var isPresented: Bool

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
                if group.groupName != "친구목록" {
                    Button {
                        withAnimation {
                            isPresented = false
                            homeViewModel.selectedGroup = group
                            mainViewModel.isEditGroupNameAlertPrsented.toggle()
                        }
                    } label: {
                        Text("그룹 이름 수정하기")
                            .foregroundStyle(.whereMediumNavy)
                    }
                }

                Button {
                    Task {
                        await homeViewModel.getNotInGroupMember()
                    }
                    withAnimation {
                        isPresented = false
                        homeViewModel.selectedGroup = group
                        homeViewModel.isGroupEditSelectAlertPrsented = true
                    }
                } label: {
                    Text("멤버 수정하기")
                        .foregroundStyle(.whereMediumNavy)
                }

                if group.groupName != "친구목록" {
                    Button {
                        withAnimation {
                            isPresented = false
                            homeViewModel.selectedGroup = group
                            mainViewModel.isDeleteGroupAlertPrsented = true
                        }
                    } label: {
                        Text("그룹 삭제하기")
                            .foregroundStyle(.red)
                    }
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
        .environmentObject(MainViewModel())
}
