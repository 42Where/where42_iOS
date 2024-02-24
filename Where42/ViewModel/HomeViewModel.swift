//
//  HomeViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isGroupEditSelectAlertPrsented = false
    @Published var isGroupMemberDeleteViewPrsented = false
    @Published var isGroupMemberAddViewPrsented = false
    @Published var isFriendDeleteAlertPresented = false
    @Published var isWorkCheked = false
    @Published var isLoading = true
    @Published var isAPILoaded = false
    @Published var inputText = ""

    @Published var isFriend = false
    @Published var viewPresentCount = 0

    @Published var newGroup: GroupInfo = .empty
    @Published var selectedMember: MemberInfo = .empty
    @Published var selectedGroup: GroupInfo = .empty
    @Published var selectedMembers: [MemberInfo] = []

    @Published var myInfo: MemberInfo = .empty
    @Published var myGroups: [GroupInfo] = [.empty, .empty]
    @Published var friends: GroupInfo = .empty
    @Published var notInGroup: GroupInfo = .init(id: UUID(), groupName: "not in group", members: [.empty])

    private let memberAPI = MemberAPI.shared
    private let groupAPI = GroupAPI.shared
    private let loginAPI = LoginAPI.shared

    // Count

    func countAllMembers() {
        countGroupMembers()
        countFriends()
    }

    func countGroupMembers() {
        for index in myGroups.indices {
            myGroups[index].totalNum = myGroups[index].members.count
            myGroups[index].onlineNum = 0
            myGroups[index].members.forEach { user in
                if user.location != "퇴근" {
                    myGroups[index].onlineNum += 1
                }
            }
        }
    }

    func countGroupMembers(group: inout GroupInfo) {
        group.totalNum = group.members.count
        group.onlineNum = 0
        group.members.forEach { user in
            if user.location != "퇴근" {
                group.onlineNum += 1
            }
        }
    }

    func countFriends() {
        friends.totalNum = friends.members.count
        friends.onlineNum = 0
        friends.members.forEach { user in
            if user.location != "퇴근" {
                friends.onlineNum += 1
            }
        }
    }

    // User

    func getMemberInfo() async {
        do {
            let responseMemberInfo = try await memberAPI.getMemberInfo()
            if responseMemberInfo == nil {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            } else {
                DispatchQueue.main.async {
                    self.myInfo = responseMemberInfo!
                    MainViewModel.shared.isLogin = true
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

    // Group

    func initNewGroup() {
        inputText = ""
        selectedMembers = []
        newGroup = .empty
    }

    func getGroup() async {
        do {
            let responseGroups = try await groupAPI.getGroup()
            DispatchQueue.main.async {
                if let responseGroups = responseGroups {
                    self.myGroups = responseGroups.map { group in
                        var sortedGroup = group
                        sortedGroup.members.sort()
                        return sortedGroup
                    }
                    self.friends = self.myGroups[responseGroups.firstIndex(
                        where: {
                            $0.groupId == self.myInfo.defaultGroupId
                        }
                    )!]
                    self.friends.members.sort()
                    self.friends.groupName = "친구목록"
                    self.friends.isOpen = true

                    self.countAllMembers()
                } else {
                    MainViewModel.shared.is42IntraSheetPresented = true
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

    func getMembersNotInGroup() async -> Bool {
        do {
            guard let responseMembers = try await groupAPI.getNotInGorupMember(groupId: selectedGroup.groupId!) else {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
                return false
            }

            DispatchQueue.main.async {
//                print(response)
                self.notInGroup.members = responseMembers
            }
            return true
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            return false
        } catch {
            return false
        }
    }

    func confirmGroupName(isNewGroupAlertPrsented: Binding<Bool>, isSelectViewPrsented: Binding<Bool>) -> String? {
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

    func createNewGroup() async {
        do {
            let groupId = try await groupAPI.createGroup(groupName: newGroup.groupName)

            if groupId != nil && selectedMembers.isEmpty == false {
                if await addMemberInGroup(groupId: groupId!) == false {
                    return
                }
                DispatchQueue.main.async {
                    self.newGroup.members = self.selectedMembers
                    self.countGroupMembers(group: &self.newGroup)
                    self.myGroups.append(self.newGroup)
                }
            } else if groupId == nil {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
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
        await getGroup()
    }

    func addMemberInGroup(groupId: Int) async -> Bool {
        do {
            let responseStatus = try await groupAPI.addMembers(groupId: groupId, members: selectedMembers)
            if responseStatus == false {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
            } else {
                DispatchQueue.main.async {
                    if let selectedIndex = self.myGroups.firstIndex(where: { $0.groupId == groupId }) {
                        self.myGroups[selectedIndex].members += self.selectedMembers
                        self.countGroupMembers()
                        self.initNewGroup()
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

    func deleteMemberInGroup() async -> Bool {
        do {
            let responseStatus = try await groupAPI.deleteGroupMember(groupId: selectedGroup.groupId!, members: selectedMembers)
            if responseStatus == false {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
                return false
            }

            DispatchQueue.main.async {
                if self.selectedGroup.groupName == "친구목록" {
                    withAnimation {
                        self.friends.members = self.selectedGroup.members.filter { member in
                            !self.selectedMembers.contains(where: { $0.intraId == member.intraId })
                        }
                    }
                } else {
                    let selectedIndex = self.myGroups.firstIndex(where: {
                        $0.groupId == self.selectedGroup.groupId
                    })

                    withAnimation {
                        self.myGroups[selectedIndex!].members = self.selectedGroup.members.filter { member in
                            !self.selectedMembers.contains(where: { $0.intraId == member.intraId })
                        }
                    }
                }

                self.initNewGroup()
                self.countAllMembers()
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

    func deleteOneMemberInGroup() async -> Bool {
        do {
            let responseStatus = try await groupAPI.deleteGroupMember(groupId: selectedGroup.groupId!, members: [selectedMember])
            if responseStatus == false {
                DispatchQueue.main.async {
                    MainViewModel.shared.is42IntraSheetPresented = true
                    MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
                }
                return false
            }

            DispatchQueue.main.async {
                if self.selectedGroup.groupName == "친구목록" {
                    withAnimation {
                        self.friends.members = self.selectedGroup.members.filter { member in
                            !(self.selectedMember.intraId == member.intraId)
                        }
                    }
                } else {
                    let selectedIndex = self.myGroups.firstIndex(where: {
                        $0.groupId == self.selectedGroup.groupId
                    })

                    withAnimation {
                        self.myGroups[selectedIndex!].members = self.selectedGroup.members.filter { member in
                            !(self.selectedMember.intraId == member.intraId)
                        }
                    }
                }

                self.initNewGroup()
                self.countAllMembers()
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

        for index in myGroups.indices {
            if myGroups[index] == selectedGroup {
                if await updateGroupName(
                    groupId: myGroups[index].groupId!,
                    newGroupName: inputText
                ) {
                    DispatchQueue.main.async {
                        self.myGroups[index].groupName = self.inputText
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
                    MainViewModel.shared.is42IntraSheetPresented = true
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
        for index in myGroups.indices {
            if myGroups[index] == selectedGroup {
                do {
                    if try await groupAPI.deleteGroup(
                        groupId: myGroups[index].groupId!
                    ) {
                        withAnimation {
                            DispatchQueue.main.async {
                                self.myGroups.remove(at: index)
                            }
                        }
                        return true
                    } else {
                        DispatchQueue.main.async {
                            MainViewModel.shared.is42IntraSheetPresented = true
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
            await logout()
            return false
        }
    }

    func logout() async {
        do {
            try await loginAPI.logout()
        } catch {}
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
