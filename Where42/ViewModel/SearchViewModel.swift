//
//  SearchViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/21/23.
//

import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searching: [MemberInfo] = []
    @Published var publisher = PassthroughSubject<String, Never>()
    @Published var isSearching = false
    @Published var name = ""
    @Published var debounceSeconds = 1.0

    private let memberAPI = MemberAPI.shared

    func searchMemeber(keyWord: String) async {
        do {
            if let searchingMember = try await memberAPI.search(keyWord: keyWord) {
//                print(searchingMember)
                DispatchQueue.main.async {
                    self.searching = searchingMember
                }
            }
        } catch {}
    }
}
