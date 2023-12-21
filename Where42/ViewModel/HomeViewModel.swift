//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowSettingSheet = false
    @Published var isShow42IntraSheet = false
    @Published var isWork = false
    @Published var isLoading = true
    @Published var inputText = ""
    @Published var intraURL: URL?

    @Published var newUsers: [GroupMemberInfo] = []
    @Published var newGroup: GroupInfo = .empty

    @Published var selectedGroup: GroupInfo = .empty

    @Published var intraId: Int = 6
    @Published var myInfo: MemberInfo = .empty

    @Published var groups: [GroupInfo] = [
        .init(groupName: "Where42", totalNum: 0, onlineNum: 0, isOpen: false, members: [
            .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun6", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun7", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun8", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun9", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun10", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun11", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근")
        ]),
        .init(groupName: "Group1", totalNum: 0, onlineNum: 0, isOpen: false, members: [
            .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun6", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun7", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun8", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun9", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun10", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun11", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun12", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun13", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun14", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun15", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
            .init(memberIntraName: "dhyun16", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
            .init(memberIntraName: "dhyun17", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~,", location: "퇴근")
        ])
    ]

    @Published var friends: GroupInfo = .init(groupName: "친구목록", totalNum: 0, onlineNum: 0, isOpen: true, members: [
        .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근")
    ])

    @Published var searching: GroupInfo = .init(groupName: "검색", totalNum: 0, onlineNum: 0, isOpen: false, members: [
        .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근")
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
                    self.countAllGroupUsers()
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

        newGroup.groupName = inputText

        isNewGroupAlertPrsented.wrappedValue.toggle()
        isSelectViewPrsented.wrappedValue.toggle()
    }

    func createNewGroup() {
        newGroup.members = newUsers

        countGroupUsers(group: &newGroup)
        groups.append(newGroup)

        initNewGroup()
    }

    func initNewGroup() {
        inputText = ""
        newUsers = []
        newGroup = GroupInfo(groupName: "", totalNum: 0, onlineNum: 0, isOpen: false, members: [])
    }

    func deleteUserInGroup(group: inout GroupInfo, name: String) {
        group.members.enumerated().forEach { index, user in
            if user.memberIntraName == name {
                group.members.remove(at: index)
            }
        }
        countGroupUsers(group: &group)
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

    func deleteGroup(isDeleteGroupAlertPrsented: Binding<Bool>) {
        for index in groups.indices {
            if groups[index] == selectedGroup {
                groups.remove(at: index)
            }
        }

        isDeleteGroupAlertPrsented.wrappedValue.toggle()
    }
}
