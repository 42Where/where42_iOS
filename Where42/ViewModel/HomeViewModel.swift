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
    @Published var isCustomLocationAlertPresented = false
    @Published var isWorkCheked = false
    @Published var isLoading = true
    @Published var isAPILoaded = false
    @Published var inputText = ""
    @Published var isFriend = false
    @Published var viewPresentCount = 0

    @Published var myInfo: MemberInfo = .empty
    @Published var myGroups: [GroupInfo] = [.empty, .empty]

    @Published var newGroup: GroupInfo = .empty
    @Published var selectedMember: MemberInfo = .empty
    @Published var selectedGroup: GroupInfo = .empty {
        didSet(oldValue) {
            if oldValue.groupId != selectedGroup.groupId || oldValue.members.count != selectedGroup.members.count {
                if let groupIndex = myGroups.firstIndex(where: { $0.groupId == selectedGroup.groupId }) {
                    selectedGroup = myGroups[groupIndex]
                }
            }
        }
    }

    @Published var selectedMembers: [MemberInfo] = []

    @Published var friends: GroupInfo = .empty {
        didSet {
            filteredFriends = friends
            filteredFriends.members = friends.members.filter { $0.inCluster == true }
        }
    }

    @Published var filteredFriends: GroupInfo = .empty {
        didSet {
            if filteredFriends.isOpen != friends.isOpen {
                friends.isOpen = filteredFriends.isOpen
            }
        }
    }

    @Published var filteredGroups: [GroupInfo] = [.empty, .empty]

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
            for member in myGroups[index].members {
                if member.inCluster == true {
                    myGroups[index].onlineNum += 1
                }
            }
        }
        setFilteredGroups()
    }

    func countGroupMembers(group: inout GroupInfo) {
        group.totalNum = group.members.count
        group.onlineNum = 0
        for member in group.members {
            if member.inCluster == true {
                group.onlineNum += 1
            }
        }
    }

    func countFriends() {
        friends.totalNum = friends.members.count
        friends.onlineNum = 0
        for member in friends.members {
            if member.inCluster == true {
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
            print("Error getMemberInfo: \(error)")
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
//                print(responseMembers)
                self.notInGroup.members = responseMembers
                self.notInGroup.members.sort()
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
        if inputText == "" || inputText.trimmingCharacters(in: .whitespaces) == "" || inputText.contains("\n") || inputText.trimmingCharacters(in: .whitespaces) != inputText {
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
                        self.myGroups[selectedIndex].members += self.selectedMembers.map { member in
                            var newMember = member
                            newMember.isCheck = false
                            return newMember
                        }
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
                if self.selectedGroup.groupId == self.friends.groupId {
                    withAnimation {
                        self.friends.members = self.selectedGroup.members.filter { member in
                            !self.selectedMembers.contains(where: { $0.intraId == member.intraId })
                        }
                    }
                } else {
                    if let selectedIndex = self.myGroups.firstIndex(where: {
                        $0.groupId == self.selectedGroup.groupId
                    }) {
                        withAnimation {
                            self.myGroups[selectedIndex].members = self.selectedGroup.members.filter { member in
                                !self.selectedMembers.contains(where: { $0.intraId == member.intraId })
                            }
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
                if self.selectedGroup.groupId == self.friends.groupId {
                    withAnimation {
                        self.friends.members = self.selectedGroup.members.filter { member in
                            self.selectedMember.intraId != member.intraId
                        }
                    }
                } else {
                    if let selectedIndex = self.myGroups.firstIndex(where: {
                        $0.groupId == self.selectedGroup.groupId
                    }) {
                        withAnimation {
                            self.myGroups[selectedIndex].members = self.selectedGroup.members.filter { member in
                                self.selectedMember.intraId != member.intraId
                            }
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
        if inputText == "" || inputText.trimmingCharacters(in: .whitespaces) == "" || inputText.contains("\n") {
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
            DispatchQueue.main.async {
                MainViewModel.shared.isLogin = false
            }
            return false
        }
    }

    func logout() async {
        do {
            try await loginAPI.logout()
        } catch {}
    }

    func setFilteredGroups() {
        filteredGroups = myGroups

        for index in 0 ..< myGroups.count {
            filteredGroups[index].members = myGroups[index].members.filter { $0.inCluster == true }
        }
    }

    func setIsOpen(groupId: Int, isOpen: Bool) {
        if let groupIndex = myGroups.firstIndex(where: { $0.groupId == groupId }) {
            myGroups[groupIndex].isOpen = isOpen
        }
        if let groupIndex = filteredGroups.firstIndex(where: { $0.groupId == groupId }) {
            filteredGroups[groupIndex].isOpen = isOpen
        }
    }
}
