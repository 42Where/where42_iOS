//
//  UserInfoModel.swift
//  Where42
//
//  Created by 현동호 on 11/8/23.
//

import Foundation
import SwiftUI

struct MemberInfo: Codable, Hashable, Comparable {
    var intraId: Int?
    var intraName: String?
    var grade: String?
    var image: String?
    var comment: String? {
        didSet {
            setComment()
        }
    }

    var inCluster: Bool?
    var agree: Bool?
    var defaultGroupId: Int?
    var location: String?
    var isCheck = false

    init(intraId: Int? = nil, intraName: String? = nil, grade: String? = nil, image: String? = nil, comment: String? = nil, inCluster: Bool? = nil, agree: Bool? = nil, defaultGroupId: Int? = nil, location: String? = nil) {
        self.intraId = intraId
        self.intraName = intraName
        self.grade = grade
        self.image = image
        self.comment = comment
        self.inCluster = inCluster
        self.agree = agree
        self.defaultGroupId = defaultGroupId
        self.location = location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.intraId = (try? container.decodeIfPresent(Int.self, forKey: .intraId)) ?? 0
        self.intraName = (try? container.decodeIfPresent(String.self, forKey: .intraName)) ?? "nil"
        self.grade = (try? container.decodeIfPresent(String.self, forKey: .grade)) ?? "nil"
        self.image = (try? container.decodeIfPresent(String.self, forKey: .image)) ?? "nil"
        self.comment = (try? container.decodeIfPresent(String.self, forKey: .comment)) ?? ""
        self.inCluster = (try? container.decodeIfPresent(Bool.self, forKey: .inCluster)) ?? nil
        self.agree = (try? container.decodeIfPresent(Bool.self, forKey: .agree)) ?? false
        self.defaultGroupId = (try? container.decodeIfPresent(Int.self, forKey: .defaultGroupId)) ?? 0
        self.location = (try? container.decodeIfPresent(String.self, forKey: .location)) ?? nil

        if inCluster == true && location == nil {
            self.location = "개포"
        } else if inCluster == false || inCluster == nil && location == nil {
            self.inCluster = false
            self.location = "퇴근"
        } else if inCluster == nil && location != nil {
            self.inCluster = true
        }
    }

    static func < (lhs: MemberInfo, rhs: MemberInfo) -> Bool {
        return lhs.intraName! < rhs.intraName!
    }

    static var empty: MemberInfo {
        MemberInfo(intraId: 0, intraName: "Name", grade: "4", image: "https://", comment: "Comment", inCluster: false)
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
