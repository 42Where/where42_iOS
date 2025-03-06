//
//  ClusterDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct CurrentLoggedInMembersDTO: Decodable {
    var members: [LoggedInMemberInfoDTO]
}

struct LoggedInMemberInfoDTO: Decodable {
    var intraId: Int
    var intraName: String
    var image: String?
    var cluster: String
    var row: Int
    var seat: Int
    var isFriend: Bool
}
