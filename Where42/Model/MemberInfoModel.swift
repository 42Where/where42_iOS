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
    var comment: String?
    var inCluster: Bool?
    var imacLocation: String?
    var customLocation: String?

    func getLocation() -> String {
        if customLocation != nil {
            return customLocation!
        } else if imacLocation != nil {
            return imacLocation!
        } else {
            return "잘못된 위치"
        }
    }

    func getComment() -> String {
        return comment ?? "코멘트를 입력해주세요"
    }
}

// struct UserInfo: Hashable {
//    var intraName: String
//    var image: String
//    var imacLocation: String
//    var comment: String
// }
