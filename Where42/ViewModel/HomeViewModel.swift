//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isShowSettingSheet = false
    @Published var isGroupEditSelectAlertPrsented = false
    @Published var isGroupMemberDeleteViewPrsented = false
    @Published var isGroupMemberAddViewPrsented = false
    @Published var isFriendDeleteAlertPresented = false
    @Published var isShow42IntraSheet = false
    @Published var isShowAgreementSheet = false
    @Published var isWork = false
    @Published var isLoading = true
    @Published var inputText = ""
    @Published var intraURL: String? = ""
    @Published var isAPILoaded = false
    @Published var isLogout = true
    @Published var isFriend = false
    @Published var viewPresentCount = 0

    @Published var selectedUser: MemberInfo = .empty
    @Published var selectedUsers: [MemberInfo] = []
    @Published var selectedGroup: GroupInfo = .empty

    @Published var newGroup: GroupInfo = .empty

    @Published var intraId: Int = 99760
    @Published var myInfo: MemberInfo = .empty

    @Published var groups: [GroupInfo] = [.empty, .empty]
    @Published var notInGroups: GroupInfo = .init(id: UUID(), groupName: "not in group", members: [.empty])

    @Published var friends: GroupInfo = .empty

    @AppStorage("isLogin") var isLogin = false

    private let memberAPI = MemberAPI.shared
    private let groupAPI = GroupAPI.shared

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
                    groups[index].onlineNum += 1
                }
            }
        }
    }

    func countGroupUsers(group: inout GroupInfo) {
        group.totalNum = group.members.count
        group.onlineNum = 0
        group.members.forEach { user in
            if user.location != "퇴근" {
                group.onlineNum += 1
            }
        }
    }

    func countFriendUsers() {
        friends.totalNum = friends.members.count
        friends.onlineNum = 0
        friends.members.forEach { user in
            if user.location != "퇴근" {
                friends.onlineNum += 1
            }
        }
    }

    // User

    func getMemberInfo() {
        Task {
            do {
                let memberInfo = try await memberAPI.getMemberInfo(intraId: self.intraId)
                if memberInfo == nil {
                    DispatchQueue.main.async {
                        self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                        self.isShow42IntraSheet = true
                        MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.myInfo = memberInfo!
                        self.isLogin = true
                    }
                }
            } catch API.NetworkError.Reissue {
                DispatchQueue.main.async {
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            } catch {
                print("Error getUserInfo: \(error)")
            }
        }
    }

    // Group

    func initNewGroup() {
        inputText = ""
        selectedUsers = []
        newGroup = GroupInfo(id: UUID(), groupName: "", totalNum: 0, onlineNum: 0, isOpen: false, members: [])
    }

    func getGroup() {
        Task {
            do {
                let responseGroups = try await groupAPI.getGroup()
                DispatchQueue.main.async {
//                    print(responseGroups[0].members)
                    if let responseGroups = responseGroups {
                        self.groups = responseGroups
                        self.friends = self.groups[responseGroups.firstIndex(
                            where: { $0.groupId == self.myInfo.defaultGroupId }
                        )!]
                        self.friends.groupName = "친구목록"
                        self.friends.isOpen = true

                        self.countOnlineUsers()
                    } else {
                        self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                        self.isShow42IntraSheet = true
                        MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                    }
                }
            } catch API.NetworkError.Reissue {
                DispatchQueue.main.async {
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            } catch {
                print("Error getGroup: \(error)")
            }
        }
    }

    func createNewGroup(intraId: Int) async {
        do {
            let groupId = try await groupAPI.createGroup(groupName: newGroup.groupName)

            if groupId != nil && selectedUsers.isEmpty == false {
                await addMemberInGroup(groupId: groupId!)
                DispatchQueue.main.async {
                    self.newGroup.members = self.selectedUsers
                    self.countGroupUsers(group: &self.newGroup)
                    self.groups.append(self.newGroup)
                }
            } else if groupId == nil {
                DispatchQueue.main.async {
                    self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                    self.isShow42IntraSheet = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            }
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        } catch {
            print("Error Create Group: \(error)")
        }

        DispatchQueue.main.async {
            self.initNewGroup()
        }
        getGroup()
    }

    func addMemberInGroup(groupId: Int) async -> Bool {
        do {
            let response = try await groupAPI.addMembers(groupId: groupId, members: selectedUsers)
            if response == false {
                DispatchQueue.main.async {
                    self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                    self.isShow42IntraSheet = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            } else {
                DispatchQueue.main.async {
                    if let selectedIndex = self.groups.firstIndex(where: { $0.groupId == groupId }) {
                        self.groups[selectedIndex].members += self.selectedUsers
                        self.countAllGroupUsers()
                    }
                }
            }
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            return false
        } catch {
            print("Failed to create new group")
        }
        return true
    }

    func confirmGroupName(isNewGroupAlertPrsented: Binding<Bool>, isSelectViewPrsented: Binding<Bool>) -> String? {
        print("confirm")
        if inputText == "" || inputText.trimmingCharacters(in: .whitespaces) == "" {
            return "wrongGroupName"
        } else if inputText.count > 40 {
            return "longGroupName"
        }

        newGroup.groupName = inputText
        isNewGroupAlertPrsented.wrappedValue = false
        isSelectViewPrsented.wrappedValue = true
        return nil
    }

    func getNotInGroupMember() async -> Bool {
        do {
            guard let response = try await groupAPI.getNotInGorupMember(groupId: selectedGroup.groupId!) else {
                DispatchQueue.main.async {
                    self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                    self.isShow42IntraSheet = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
                return false
            }

            DispatchQueue.main.async {
//                print(response)
                self.notInGroups.members = response
            }
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            return false
        } catch {}
        return true
    }

    func deleteUserInGroup() async -> Bool {
        do {
            let response = try await groupAPI.deleteGroupMember(groupId: selectedGroup.groupId!, members: selectedUsers)
            if response == false {
                DispatchQueue.main.async {
                    self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                    self.isShow42IntraSheet = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
                return false
            }

            DispatchQueue.main.async {
                if self.selectedGroup.groupName == "친구목록" {
                    withAnimation {
                        self.friends.members = self.selectedGroup.members.filter { member in
                            !self.selectedUsers.contains(where: { $0.intraId == member.intraId })
                        }
                    }
                } else {
                    let selectedIndex = self.groups.firstIndex(where: {
                        $0.groupName == self.selectedGroup.groupName
                    })

                    withAnimation {
                        self.groups[selectedIndex!].members = self.selectedGroup.members.filter { member in
                            !self.selectedUsers.contains(where: { $0.intraId == member.intraId })
                        }
                    }
                }

                self.initNewGroup()
                self.countOnlineUsers()
            }
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후  다시 시도해 주세요")
            }
            return false
        } catch {
            print("Failed delete group member")
        }
        return true
    }

    func editGroupName() async -> String? {
        if inputText == "" || inputText.trimmingCharacters(in: .whitespaces) == "" {
            return "wrongGroupName"
        } else if inputText.count > 40 {
            return "longGroupName"
        }

        for index in groups.indices {
            if groups[index] == selectedGroup {
                if await updateGroupName(
                    groupId: groups[index].groupId!,
                    newGroupName: inputText
                ) {
                    DispatchQueue.main.async {
                        self.groups[index].groupName = self.inputText
                        self.inputText = ""
                        self.selectedGroup = .empty
                    }
                } else {
                    return "reissue"
                }
            }
        }
        return nil
    }

    func updateGroupName(groupId: Int, newGroupName: String) async -> Bool {
        do {
            guard let _ = try await groupAPI.updateGroupName(
                groupId: groupId,
                newGroupName: newGroupName
            ) else {
                DispatchQueue.main.async {
                    self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                    self.isShow42IntraSheet = true
                }
                throw API.NetworkError.Reissue
            }
            return true
        } catch API.NetworkError.Reissue {
            return false
        } catch {
            return false
        }
    }

    func deleteGroup() async -> Bool {
        for index in groups.indices {
            if groups[index] == selectedGroup {
                do {
                    if try await groupAPI.deleteGroup(
                        groupId: groups[index].groupId!
                    ) {
                        withAnimation {
                            DispatchQueue.main.async {
                                self.groups.remove(at: index)
                            }
                        }
                        return true
                    } else {
                        DispatchQueue.main.async {
                            self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                            self.isShow42IntraSheet = true
                            MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                        }
                        return false
                    }
                } catch API.NetworkError.Reissue {
                    DispatchQueue.main.async {
                        MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                    }
                } catch {
                    return false
                }
            }
        }
        return false
    }

    func reissue() async -> Bool {
        do {
            try await API.sharedAPI.reissue()
            return true
        } catch {
            print("reissue failed")
            return false
        }
    }

    func resetAccesstoken() {
        DispatchQueue.main.async {
            API.sharedAPI.accessToken = ""
            print("access token: ", API.sharedAPI.accessToken)
        }
    }

    func expireAccesstoken() {
        DispatchQueue.main.async {
            API.sharedAPI.accessToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVc2VyIiwiaW50cmFJZCI6OTk3NjAsImludHJhTmFtZSI6ImRoeXVuIiwicm9sZXMiOiJDYWRldCIsImlhdCI6MTcwNjEwMTExNiwiaXNzIjoid2hlcmU0MiIsImV4cCI6MTcwNjEwNDcxNn0.1VmKO3KZ5Eze6bKK5S4Rd23HxWYOCu2tJDjCFRS1D6c"
            print("access token: ", API.sharedAPI.accessToken)
        }
    }

    func resetRefreshtoken() {
        DispatchQueue.main.async {
            API.sharedAPI.refreshToken = ""
            print("refresh token: ", API.sharedAPI.refreshToken)
        }
    }

    func expireRefreshtoken() {
        DispatchQueue.main.async {
            API.sharedAPI.refreshToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJVc2VyIiwiaW50cmFJZCI6OTk3NjAsImludHJhTmFtZSI6ImRoeXVuIiwicm9sZXMiOiJDYWRldCIsImlhdCI6MTcwNjEwMTExNiwiaXNzIjoid2hlcmU0MiIsImV4cCI6MTcwNjEwNDcxNn0.1VmKO3KZ5Eze6bKK5S4Rd23HxWYOCu2tJDjCFRS1D6c"
            print("refresh token: ", API.sharedAPI.refreshToken)
        }
    }
}
