//
//  SearchViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/21/23.
//

import Combine
import SwiftUI

enum SearchStatus {
    case waiting
    case searching
    case apiCalled
}

class SearchViewModel: ObservableObject {
    @Published var searching: [MemberInfo] = []
    @Published var selectedMembers: [MemberInfo] = [] {
        didSet {
            if selectedMembers.count > 0 {
                isTabBarPresented = true
            } else {
                isTabBarPresented = false
            }
        }
    }

    @Published var isTabBarPresented = false
    @Published var publisher = PassthroughSubject<String, Never>()
    @Published var searchStatus: SearchStatus = .waiting
    @Published var name = ""
    @Published var debounceSeconds = 1.0

    private let memberAPI = MemberAPI.shared
    private let groupAPI = GroupAPI.shared

    func search(keyWord: String) {
        if searchStatus == .searching {
            searchStatus = .apiCalled
            Task {
                await searchMemeber(keyWord: keyWord)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.searchStatus = .waiting
                    if self.name == "" {
                        self.searching = []
                    }
                }
            }
        }
    }

    func searchMemeber(keyWord: String) async {
        do {
            if let searchingMember = try await memberAPI.search(keyWord: keyWord) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if self.searchStatus == .apiCalled {
                        self.searching = searchingMember.map { memberInfo in
                            var member = memberInfo
                            if self.selectedMembers.contains(where: { $0.intraId == memberInfo.intraId }) {
                                member.isCheck = true
                            }
                            return member
                        }
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        }
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.initSearchingAfterAdd()
                }
            }
        } catch NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            return false
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed add members")
        }
        return true
    }

    func initSearchingAfterAdd() {
        withAnimation {
            searching = searching.map { member in
                var updateMember = member
                updateMember.isCheck = false
                return updateMember
            }
            name = ""
            selectedMembers = []
        }
    }
}
