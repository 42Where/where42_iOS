//
//  SearchViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/21/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searching: GroupInfo = .init(name: "검색", totalNum: 0, onlineNum: 0, isOpen: false, users: [
        .init(name: "dhyun1", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun2", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~"),
        .init(name: "dhyun3", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요~"),
        .init(name: "dhyun4", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")
    ])
}
