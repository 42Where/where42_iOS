//
//  SearchViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/21/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searching: GroupInfo = .init(id: UUID(), groupName: "검색", totalNum: 0, onlineNum: 0, isOpen: false, members: [
        .init(memberIntraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(memberIntraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(memberIntraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근")
    ])
}
