//
//  GroupDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct CreateGroupDTO: Codable {
    var groupName: String
}

struct UpdateGroupDTO: Codable {
    var groupId: Int
    var groupName: String
}

struct UpdateGroupMemberDTO: Codable {
    var groupId: Int
    var members: [Int]
}

struct AddOneGroupMemberDTO: Codable {
    var intraId: Int
    var groupId: Int
}
