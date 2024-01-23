//
//  HomeAlertView.swift
//  Where42
//
//  Created by 현동호 on 11/18/23.
//

import SwiftUI

struct MainAlertView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        if mainViewModel.isNewGroupAlertPrsented {
            CustomAlert(
                title: "새 그룹 만들기",
                textFieldTitle: "그룹명 지정",
                inputText: $homeViewModel.inputText)
            {
                withAnimation {
                    homeViewModel.initNewGroup()
                    mainViewModel.isNewGroupAlertPrsented = false
                }
            } rightButtonAction: {
                withAnimation {
                    homeViewModel.confirmGroupName(
                        isNewGroupAlertPrsented: $mainViewModel.isNewGroupAlertPrsented,
                        isSelectViewPrsented: $mainViewModel.isSelectViewPrsented)
                }
            }
        }

        if mainViewModel.isEditGroupNameAlertPrsented {
            CustomAlert(
                title: "그룹 이름 수정",
                textFieldTitle: "그룹 이름을 입력해주세요",
                inputText: $homeViewModel.inputText)
            {
                withAnimation {
                    homeViewModel.initNewGroup()
                    mainViewModel.isEditGroupNameAlertPrsented = false
                }
            } rightButtonAction: {
                if await homeViewModel.editGroupName() {
                    withAnimation {
                        mainViewModel.isEditGroupNameAlertPrsented = false
                    }
                }
            }
        }

        if mainViewModel.isDeleteGroupAlertPrsented {
            CustomAlert(
                title: "그룹 삭제",
                message: " 그룹 '\(homeViewModel.selectedGroup.groupName)' 을(를) 삭제하시겠습니까?",
                inputText: .constant(""))
            {
                withAnimation {
                    mainViewModel.isDeleteGroupAlertPrsented = false
                }
            } rightButtonAction: {
                if await homeViewModel.deleteGroup() {
                    withAnimation {
                        mainViewModel.isDeleteGroupAlertPrsented = false
                    }
                }
            }
        }

        if homeViewModel.isFriendDeleteAlertPresented {
            if homeViewModel.isFriend {
                CustomAlert(
                    title: "친구 삭제",
                    message: " 친구 '\(homeViewModel.selectedUser.intraName!)'님을 친구목록에서 삭제하시겠습니까?",
                    inputText: .constant(""))
                {
                    withAnimation {
                        homeViewModel.isFriendDeleteAlertPresented = false
                    }
                } rightButtonAction: {
                    await homeViewModel.deleteUserInGroup()
                    withAnimation {
                        homeViewModel.isFriendDeleteAlertPresented = false
                    }
                }
            } else {
                CustomAlert(
                    title: "멤버 삭제",
                    message: " 멤버 '\(homeViewModel.selectedUser.intraName!)'님을 그룹에서 삭제하시겠습니까?",
                    inputText: .constant(""))
                {
                    withAnimation {
                        homeViewModel.isFriendDeleteAlertPresented = false
                    }
                } rightButtonAction: {
                    await homeViewModel.deleteUserInGroup()
                    withAnimation {
                        homeViewModel.isFriendDeleteAlertPresented = false
                    }
                }
            }
        }

        if homeViewModel.isGroupEditSelectAlertPrsented {
            GroupEditSelectModal()
        }
    }
}

#Preview {
    MainAlertView()
        .environmentObject(HomeViewModel())
        .environmentObject(MainViewModel())
}
