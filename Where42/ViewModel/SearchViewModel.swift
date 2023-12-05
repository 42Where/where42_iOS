//
//  SearchViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/21/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searching: GroupInfo = .init(name: "검색", totalNum: 0, onlineNum: 0, isOpen: false, users: [
        .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근"),
        .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "개포 c2r5s6"),
        .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", imacLocation: "퇴근")
    ])
}
