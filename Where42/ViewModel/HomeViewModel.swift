//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowSettingSheet = false
    @Published var isWork = false

    @Published var inputText = ""
    @Published var newUsers: [MemberInfo] = []
    @Published var newGroup: GroupInfo = .empty

    @Published var selectedGroup: GroupInfo = .empty

    @Published var intraId: Int = 99760

//    @Published var myInfo: MemberInfo = .init(intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근")
    @Published var myInfo: MemberInfo = .empty

    @Published var groups: [GroupInfo] = [
        .init(name: "Where42", totalNum: 0, onlineNum: 0, isOpen: false, users: [
            .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun6", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun7", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun8", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun9", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun10", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun11", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근")
        ]),
        .init(name: "Group1", totalNum: 0, onlineNum: 0, isOpen: false, users: [
            .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun6", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun7", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun8", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun9", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun10", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun11", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun12", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun13", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun14", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun15", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
            .init(intraName: "dhyun16", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
            .init(intraName: "dhyun17", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~,", imacLocation: "퇴근")
        ])
    ]

    @Published var friends: GroupInfo = .init(name: "친구목록", totalNum: 0, onlineNum: 0, isOpen: true, users: [
        .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
        .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근")
    ])

    @Published var searching: GroupInfo = .init(name: "검색", totalNum: 0, onlineNum: 0, isOpen: false, users: [
        .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
        .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근")
    ])

    private let memberAPI = MemberAPI()

    // Count

    func countOnlineUsers() {
        countFriendUsers()
        countAllGroupUsers()
    }

    func countAllGroupUsers() {
        for index in groups.indices {
            groups[index].totalNum = groups[index].users.count
            groups[index].onlineNum = 0
            groups[index].users.forEach { user in
                if user.imacLocation != "퇴근" {
                    groups[index].onlineNum += 1
                }
            }
        }
    }

    func countGroupUsers(group: inout GroupInfo) {
        group.totalNum = group.users.count
        group.onlineNum = 0
        group.users.forEach { user in
            if user.imacLocation != "퇴근" {
                group.onlineNum += 1
            }
        }
    }

    func countFriendUsers() {
        friends.totalNum = friends.users.count
        friends.onlineNum = 0
        friends.users.forEach { user in
            if user.imacLocation != "퇴근" {
                friends.onlineNum += 1
            }
        }
    }

    // User

    func getMemberInfo() {
        Task {
            do {
                let memberInfo = try await memberAPI.getMemberInfo(intraId: self.intraId)
                DispatchQueue.main.async {
//                    print(memberInfo)
                    self.myInfo = memberInfo
                }
            } catch {
                print("Error getUserInfo: \(error)")
            }
        }
    }

    // Create New Group

    func confirmGroupName(isNewGroupAlertPrsented: Binding<Bool>, isSelectViewPrsented: Binding<Bool>) {
        if inputText == "" {
            return
        }

        newGroup.name = inputText

        isNewGroupAlertPrsented.wrappedValue.toggle()
        isSelectViewPrsented.wrappedValue.toggle()
    }

    func createNewGroup() {
        newGroup.users = newUsers

        countGroupUsers(group: &newGroup)
        groups.append(newGroup)

        initNewGroup()
    }

    func initNewGroup() {
        inputText = ""
        newUsers = []
        newGroup = GroupInfo(name: "", totalNum: 0, onlineNum: 0, isOpen: false, users: [])
    }

    func deleteUserInGroup(group: inout GroupInfo, name: String) {
        group.users.enumerated().forEach { index, user in
            if user.intraName == name {
                group.users.remove(at: index)
            }
        }
        countGroupUsers(group: &group)
    }

    func addUserInGroup(group: inout GroupInfo, userInfo: MemberInfo) {
        group.users.forEach { user in
            if user.intraName == userInfo.intraName {
                return
            }
        }
        group.users.append(userInfo)
    }

    // Edit Group

    func editGroupName(isEditGroupNameAlertPrsented: Binding<Bool>) {
        if inputText == "" {
            return
        }

        for index in groups.indices {
            if groups[index] == selectedGroup {
                groups[index].name = inputText
            }
        }

        inputText = ""
        selectedGroup = .empty
        isEditGroupNameAlertPrsented.wrappedValue.toggle()
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
