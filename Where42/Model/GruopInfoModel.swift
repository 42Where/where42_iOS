//
//  GruopModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation

struct GroupInfo: Hashable {
    var name: String
    var totalNum: Int
    var onlineNum: Int
    var isOpen: Bool
    var users: [UserInfo] = []

    static var empty: GroupInfo {
        GroupInfo(name: "", totalNum: 0, onlineNum: 0, isOpen: false)
    }
}
