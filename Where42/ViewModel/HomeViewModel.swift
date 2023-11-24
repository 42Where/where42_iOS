//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Alamofire
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowSettingSheet = false
    @Published var isWork = false

    @Published var inputText = ""
    @Published var newUsers: [UserInfo] = []
    @Published var newGroup: GroupInfo = .empty

    @Published var selectedGroup: GroupInfo = .empty

    @Published var dhyun: UserInfo = .init(name: "dhyun", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")

    @Published var groups: [GroupInfo] = [
        .init(name: "Where42", totalNum: 0, onlineNum: 0, isOpen: false, users: [
            .init(name: "dhyun1", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun2", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun3", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun4", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun5", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun6", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun7", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun8", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun9", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun10", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun11", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")
        ]),
        .init(name: "Group1", totalNum: 0, onlineNum: 0, isOpen: false, users: [
            .init(name: "dhyun1", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun2", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun3", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun4", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun5", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun6", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun7", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun8", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun9", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun10", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun11", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun12", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun13", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun14", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun15", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
            .init(name: "dhyun16", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
            .init(name: "dhyun17", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")
        ])
    ]

    @Published var friends: GroupInfo = .init(name: "친구목록", totalNum: 0, onlineNum: 0, isOpen: true, users: [
        .init(name: "dhyun1", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun2", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
        .init(name: "dhyun3", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun4", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")
    ])

    @Published var searching: GroupInfo = .init(name: "검색", totalNum: 0, onlineNum: 0, isOpen: false, users: [
        .init(name: "dhyun1", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun2", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
        .init(name: "dhyun3", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun4", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")
    ])

    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""

    // User

    func getUserInfo() {
        AF.request(
            baseURL + "/member/info",
            method: .get
        )
        .validate(statusCode: 200 ..< 500)
        .responseDecodable(of: ResponseWithUserInfo.self) { response in
            switch response.result {
            case .success(let value):
                print("성공하였습니다 :: \(value)")
                self.dhyun.name = value.data.name

            case .failure(let error):
                print("실패하였습니다 :: \(error)")
            }
        }
    }

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
                if user.location != "퇴근" {
                    groups[index].onlineNum += 1
                }
            }
        }
    }

    func countGroupUsers(group: inout GroupInfo) {
        group.totalNum = group.users.count
        group.onlineNum = 0
        group.users.forEach { user in
            if user.location != "퇴근" {
                group.onlineNum += 1
            }
        }
    }

    func countFriendUsers() {
        friends.totalNum = friends.users.count
        friends.onlineNum = 0
        friends.users.forEach { user in
            if user.location != "퇴근" {
                friends.onlineNum += 1
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
        print(groups)
    }

    func initNewGroup() {
        inputText = ""
        newUsers = []
        newGroup = GroupInfo(name: "", totalNum: 0, onlineNum: 0, isOpen: false, users: [])
    }

    func deleteUser(group: inout GroupInfo, name: String) {
        group.users.enumerated().forEach { index, user in
            if user.name == name {
                group.users.remove(at: index)
            }
        }
        countGroupUsers(group: &group)
    }

    func addUser(group: inout GroupInfo, userInfo: UserInfo) {
        group.users.forEach { user in
            if user.name == userInfo.name {
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
