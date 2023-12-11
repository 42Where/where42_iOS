//
//  GruopModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation

struct GroupMemberDTO: Hashable, Codable {
    var groupId: Int
    var groupName: String
    var memberId: Int
    var comment: String
    var memberIntraName: String
    var customLocation: String
    var imacLocation: String
    var clusterLocation: String
    var inCluster: Bool
    var image: String
}

struct GroupInfo: Hashable, Codable {
    var groupId: Int?
    var name: String
    var totalNum: Int
    var onlineNum: Int?
    var isOpen: Bool?
    var members: [MemberInfo] = []

    enum Codingkeys: String, CodingKey {
        case groupId
        case name = "groupName"
        case totalNum = "count"
        case members
    }

    static var empty: GroupInfo {
        GroupInfo(name: "", totalNum: 0, onlineNum: 0, isOpen: false)
    }
}
