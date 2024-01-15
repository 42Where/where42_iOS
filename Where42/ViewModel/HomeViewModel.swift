//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowSettingSheet = false
    @Published var isGroupEditViewPrsented = false
    @Published var isShow42IntraSheet = false
    @Published var isShowAgreementSheet = false
    @Published var isWork = false
    @Published var isLoading = true
    @Published var inputText = ""
    @Published var intraURL: String? = ""
    @Published var isAPILoaded = false

    @Published var selectedUsers: [MemberInfo] = []
    @Published var newGroup: GroupInfo = .empty

    @Published var selectedGroup: GroupInfo = .empty

    @Published var intraId: Int = 99760
    @Published var myInfo: MemberInfo = .empty

    @Published var groups: [GroupInfo] = [.empty, .empty]

    @Published var friends: GroupInfo = .empty

    @AppStorage("isLogin") var isLogin = false

    private let memberAPI = MemberAPI()
    private let groupAPI = GroupAPI()

    // Count

    func countOnlineUsers() {
        countFriendUsers()
        countAllGroupUsers()
    }

    func countAllGroupUsers() {
        for index in groups.indices {
            groups[index].totalNum = groups[index].members.count
            groups[index].onlineNum = 0
            groups[index].members.forEach { user in
                if user.location != "퇴근" {
                    groups[index].onlineNum! += 1
                }
            }
        }
    }

    func countGroupUsers(group: inout GroupInfo) {
        group.totalNum = group.members.count
        group.onlineNum = 0
        group.members.forEach { user in
            if user.location != "퇴근" {
                group.onlineNum! += 1
            }
        }
    }

    func countFriendUsers() {
        friends.totalNum = friends.members.count
        friends.onlineNum = 0
        friends.members.forEach { user in
            if user.location != "퇴근" {
                friends.onlineNum! += 1
            }
        }
    }

    // User

    func getMemberInfo() {
        Task {
            do {
                let (memberInfo, url) = try await memberAPI.getMemberInfo(intraId: self.intraId)
                if url != nil {
                    DispatchQueue.main.async {
                        self.intraURL = url
                        self.isShow42IntraSheet.toggle()
                    }
                } else {
                    DispatchQueue.main.async {
                        if memberInfo != nil {
                            self.myInfo = memberInfo!
                            if self.myInfo.comment == nil {
                                self.myInfo.comment = ""
                            }
                            self.isLogin = true
                        } else {
                            self.isLogin = false
                        }
                    }
                }
            } catch {
                print("Error getUserInfo: \(error)")
            }
        }
    }

    // Group

    func getGroup() {
        Task {
            do {
                let responseGroups = try await groupAPI.getGroup()
                DispatchQueue.main.async {
//                    print(responseGroups[0].members)
                    if let responseGroups = responseGroups {
                        self.groups = responseGroups
                        self.friends = responseGroups[responseGroups.firstIndex(
                            where: { $0.groupName == "default" }
                        )!]
                        self.friends.isOpen = true

                        self.countOnlineUsers()
                    } else {
                        self.isLogin = false
                    }
                }
            } catch {
                print("Error getGroup: \(error)")
            }
        }
    }

    func updateGroupName(groupId: Int, newGroupName: String) async -> Bool {
        do {
            let newName = try await groupAPI.updateGroupName(groupId: groupId, newGroupName: newGroupName)
            print(newName!)
            return true
        } catch {
            return false
        }
    }

    // Create New Group

    func confirmGroupName(isNewGroupAlertPrsented: Binding<Bool>, isSelectViewPrsented: Binding<Bool>) {
        print("confirm")
        if inputText == "" {
            return
        }

        let duplicateName: Int? = groups.firstIndex(where: { $0.groupName == inputText })

        if duplicateName != nil {
            return
        }

        newGroup.groupName = inputText

        DispatchQueue.main.async {
            isNewGroupAlertPrsented.wrappedValue.toggle()
            isSelectViewPrsented.wrappedValue.toggle()
        }
    }

    func createNewGroup(intraId: Int) async {
        DispatchQueue.main.async {
            self.newGroup.members = self.selectedUsers

            self.countGroupUsers(group: &self.newGroup)
            self.groups.append(self.newGroup)
        }

        let groupId = try? await groupAPI.createGroup(groupName: newGroup.groupName)

        if groupId != nil && selectedUsers.isEmpty == false {
            do {
                _ = try await groupAPI.addMembers(groupId: groupId!, members: selectedUsers)
            } catch {
                print("Failed to create new group")
            }
        }

        DispatchQueue.main.async {
            self.initNewGroup()
            self.getGroup()
        }
    }

    func initNewGroup() {
        inputText = ""
        selectedUsers = []
        newGroup = GroupInfo(id: UUID(), groupName: "", totalNum: 0, onlineNum: 0, isOpen: false, members: [])
    }

    func deleteUserInGroup() async {
        do {
            _ = try await groupAPI.deleteGroupMember(groupId: selectedGroup.groupId!, members: selectedUsers)

            let selectedIndex = groups.firstIndex(where: {
                $0.groupName == selectedGroup.groupName
            })

            DispatchQueue.main.async {
                self.groups[selectedIndex!].members = self.selectedGroup.members.filter { member in
                    !self.selectedUsers.contains(where: { $0.intraId == member.intraId })
                }

                self.initNewGroup()
                self.countOnlineUsers()
            }
        } catch {
            print("Failed delete group member")
        }
    }

    func addUserInGroup(group: inout GroupInfo, userInfo: MemberInfo) {
        group.members.forEach { user in
            if user.intraName == userInfo.intraName {
                return
            }
        }
        group.members.append(userInfo)
    }

    // Edit Group

    func editGroupName() async -> Bool {
        if inputText == "" {
            return false
        }

        for index in groups.indices {
            if groups[index] == selectedGroup {
                DispatchQueue.main.async {
                    self.groups[index].groupName = self.inputText
                }

                if await updateGroupName(groupId: groups[index].groupId!, newGroupName: inputText) {
                    DispatchQueue.main.async {
                        self.inputText = ""
                        self.selectedGroup = .empty
                    }
                } else {
                    return false
                }
            }
        }
        return true
    }

    func deleteGroup() async -> Bool {
        for index in groups.indices {
            if groups[index] == selectedGroup {
                do {
                    if try await groupAPI.deleteGroup(
                        groupId: groups[index].groupId!
                    ) {
//                        withAnimation {
                        DispatchQueue.main.async {
                            self.groups.remove(at: index)
                        }
                        return true
                    }
                } catch {
                    return false
                }
            }
        }
        return false
    }
}
