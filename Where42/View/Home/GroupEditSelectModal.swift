//
//  GroupEditSelectModel.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct GroupEditSelectModal: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.30)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        homeViewModel.isGroupEditSelectAlertPrsented = false
                    }
                }

            VStack(spacing: 25) {
                Text("멤버 편집 기능을 선택해주세요")
                    .font(.custom(Font.GmarketBold, size: 17))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5.0)

                HStack {
                    if homeViewModel.selectedGroup.groupName != "친구목록" {
                        Button {
                            homeViewModel.selectedMembers = []
                            withAnimation {
                                homeViewModel.isGroupEditSelectAlertPrsented = false
                                homeViewModel.isGroupMemberAddViewPrsented = true
                            }
                        } label: {
                            Text("멤버 추가하기")
                                .font(.custom(Font.GmarketMedium, size: 15))
                                .padding(8)
                                .foregroundStyle(.whereDeepNavy)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.whereDeepNavy, lineWidth: 1)
                                )
                        }

                        Spacer()
                    }

                    Button {
                        homeViewModel.selectedMembers = []
                        withAnimation {
                            homeViewModel.isGroupEditSelectAlertPrsented = false
                            homeViewModel.isGroupMemberDeleteViewPrsented = true
                        }
                    } label: {
                        Text("멤버 삭제하기")
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .padding(8.5)
                            .foregroundStyle(.white)
                            .background(.whereDeepNavy)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
            }
            .padding(20)
            .padding(.vertical, 5)
            .frame(width: UIDevice.idiom == .phone ? 270 : 370)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    GroupEditSelectModal()
        .environmentObject(HomeViewModel())
}
