//
//  UserInfoModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation
import SwiftUI

struct UserInfo: Hashable {
    var name: String
    var avatar: String
    var location: String
    var comment: String
}

struct ResponseWithUserInfo: Codable {
    var statusCode: Int
    var responseMsg: String
    var data: TestUserInfo
}

struct TestUserInfo: Codable {
    var name: String
}
