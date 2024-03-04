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
    @Published var publisher = PassthroughSubject<String, Never>()
    @Published var searchStatus: SearchStatus = .waiting
    @Published var name = ""
    @Published var debounceSeconds = 1.0

    private let memberAPI = MemberAPI.shared

    func search(keyWord: String) {
        if searchStatus == .searching {
            searchStatus = .apiCalled
            Task {
                await searchMemeber(keyWord: keyWord)
                DispatchQueue.main.async {
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
                DispatchQueue.main.async {
                    if self.searchStatus == .apiCalled {
                        self.searching = searchingMember
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        }
    }

    func initSearchingAfterAdd() {
        withAnimation {
            searching = searching.map { member in
                var updateMember = member
                updateMember.isCheck = false
                return updateMember
            }
            name = ""
        }
    }
}
