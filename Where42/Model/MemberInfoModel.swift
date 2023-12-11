//
//  UserInfoModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation
import SwiftUI

struct MemberInfo: Codable, Hashable {
    var id: Int?
    var intraId: Int?
    var intraName: String?
    var grade: Int?
    var image: String?
    var comment: String? {
        didSet {
            setComment()
        }
    }

    var inCluster: Bool? = false
    var agree: Bool?
    var defaultGrouId: String?
    var location: String?

    static var empty: MemberInfo {
        MemberInfo(id: 0, intraId: 0, intraName: "Name", grade: 0, image: "https://", comment: "Comment", inCluster: false)
    }

    func getLocation() -> String {
        if location != nil {
            return location!
        } else {
            return "잘못된 위치"
        }
    }

    mutating func setComment() {
        if comment == nil {
            comment = "코멘트를 입력해주세요"
        }
    }
}

// struct UserInfo: Hashable {
//    var intraName: String
//    var image: String
//    var imacLocation: String
//    var comment: String
// }
