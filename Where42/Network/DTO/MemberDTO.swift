//
//  MemberDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct CreateMemberDTO: Codable {
    var intraId: Int
    var intraName: String?
    var grade: Int?
    var image: String?
}

struct UpdateCommentDTO: Codable {
    var comment: String?
}

struct UpdateCustomLocationDTO: Codable {
    var customLocation: String?
}

struct DeleteMemberDTO: Codable {
    var intraId: Int
}
