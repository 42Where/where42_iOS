//
//  GruopModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation

struct GroupInfo: Identifiable, Equatable, Codable {
    var id: UUID

    var groupId: Int = 0
    var groupName: String
    var totalNum: Int = 0
    var onlineNum: Int = 0
    var isOpen: Bool = false
    var members: [MemberInfo] = [] {
        didSet {
            countGroupMembers()
        }
    }

    enum CodingKeys: String, CodingKey {
        case groupId, groupName, members
        case totalNum = "count"
    }

    init(id: UUID, groupId: Int, groupName: String, totalNum: Int = 0, onlineNum: Int = 0, isOpen: Bool = false, members: [MemberInfo]) {
        self.id = id
        self.groupId = groupId
        self.groupName = groupName
        self.totalNum = totalNum
        self.onlineNum = onlineNum
        self.isOpen = isOpen
        self.members = members
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = UUID()
        self.groupId = (try? container.decodeIfPresent(Int.self, forKey: .groupId)) ?? 0
        self.groupName = (try? container.decodeIfPresent(String.self, forKey: .groupName)) ?? "nil"
        self.members = (try? container.decodeIfPresent([MemberInfo].self, forKey: .members)) ?? []
        self.totalNum = (try? container.decodeIfPresent(Int.self, forKey: .totalNum)) ?? 0
    }

    static var empty: GroupInfo {
        GroupInfo(id: UUID(), groupId: 0, groupName: "", totalNum: 0, onlineNum: 0, isOpen: false, members: [])
    }

    mutating func countGroupMembers() {
        totalNum = members.count
        onlineNum = 0
        for member in members {
            if member.inCluster == true {
                onlineNum += 1
            }
        }
    }
}
