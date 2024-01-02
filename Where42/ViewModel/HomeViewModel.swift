//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isGroupEditViewPrsented = false
    @Published var isShowSettingSheet = false
    @Published var isShow42IntraSheet = false
    @Published var isWork = false
    @Published var isLoading = true
    @Published var inputText = ""
    @Published var intraURL: URL?
    @Published var isAPILoaded = false

    @Published var selectedUsers: [GroupMemberInfo] = []
    @Published var newGroup: GroupInfo = .empty

    @Published var selectedGroup: GroupInfo = .empty

    @Published var intraId: Int = 6
    @Published var myInfo: MemberInfo = .empty

    @Published var groups: [GroupInfo] = [.empty, .empty]

    @Published var friends: GroupInfo = .empty

    @Published var searching: GroupInfo = .init(groupName: "검색", totalNum: 0, onlineNum: 0, isOpen: false, members: [
        .init(intraId: 1, memberIntraName: "member0", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraId: 2, memberIntraName: "member1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(intraId: 3, memberIntraName: "member2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraId: 4, memberIntraName: "member3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근")
    ])

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
                    intraURL = url
                    isShow42IntraSheet.toggle()
                } else {
                    DispatchQueue.main.async {
                        self.myInfo = memberInfo!
                        if self.myInfo.comment == nil {
                            self.myInfo.comment = ""
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
                let responseGroups = try await groupAPI.getGroup(intraId: self.intraId)
                DispatchQueue.main.async {
//                    print("-------------------")
//                    print(responseGroups[0].members)
                    self.groups = responseGroups
                    self.friends = responseGroups[responseGroups.firstIndex(where: { $0.groupName == "default" })!]
                    self.friends.isOpen = true

                    self.countOnlineUsers()
                }
            } catch {
                print("Error getGroup: \(error)")
            }
        }
    }

    func updateGroupName(groupId: Int, newGroupName: String) async -> Bool {
        do {
            let newName = try await groupAPI.updateGroupName(groupId: groupId, newGroupName: newGroupName)
            print(newName)
            return true
        } catch {
            return false
        }
    }

    // Create New Group

    func confirmGroupName(isNewGroupAlertPrsented: Binding<Bool>, isSelectViewPrsented: Binding<Bool>) {
        if inputText == "" {
            return
        }

        let duplicateName: Int? = groups.firstIndex(where: { $0.groupName == inputText })

        if duplicateName != nil {
            return
        }

        newGroup.groupName = inputText

        isNewGroupAlertPrsented.wrappedValue.toggle()
        isSelectViewPrsented.wrappedValue.toggle()
    }

    func createNewGroup(intraId: Int) async {
        newGroup.members = selectedUsers

        countGroupUsers(group: &newGroup)
        groups.append(newGroup)

        let groupId = try? await groupAPI.createGroup(intraId: intraId, groupName: newGroup.groupName)

        if groupId != nil && selectedUsers.isEmpty == false {
            await groupAPI.addMembers(groupId: groupId!, members: selectedUsers)
        }

        initNewGroup()
        getGroup()
    }

    func initNewGroup() {
        inputText = ""
        selectedUsers = []
        newGroup = GroupInfo(groupName: "", totalNum: 0, onlineNum: 0, isOpen: false, members: [])
    }

    func deleteUserInGroup() async {
        do {
            _ = try await groupAPI.deleteGroupMember(groupId: selectedGroup.groupId!, members: selectedUsers)

            let selectedIndex = groups.firstIndex(where: {
                $0.groupName == selectedGroup.groupName
            })

            groups[selectedIndex!].members = selectedGroup.members.filter { member in
                !selectedUsers.contains(where: { $0.intraId == member.intraId })
            }

            initNewGroup()
            countOnlineUsers()
        } catch {
            fatalError("Failed delete group member")
        }
    }

    func addUserInGroup(group: inout GroupInfo, userInfo: GroupMemberInfo) {
        group.members.forEach { user in
            if user.memberIntraName == userInfo.memberIntraName {
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
                groups[index].groupName = inputText

                if await updateGroupName(groupId: groups[index].groupId!, newGroupName: inputText) {
                    inputText = ""
                    selectedGroup = .empty
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
                    if try await groupAPI.deleteGroup(groupId: groups[index].groupId!, groupName: groups[index].groupName) {
                        withAnimation {
                            groups.remove(at: index)
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
