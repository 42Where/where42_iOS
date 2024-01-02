//
//  File.swift
//  Where42
//
//  Created by 현동호 on 12/18/23.
//

import Foundation
import SwiftUI

struct GroupMemberInfo: Codable, Hashable {
    var groupId: Int?
    var groupName: String?
    var intraId: Int?
    var memberIntraName: String?
    var grade: String?
    var image: String?
    var comment: String? {
        didSet {
            setComment()
        }
    }

    var inCluster: Bool? = false
    var agree: Bool?
    var defaultGroupId: Int?
    var location: String?

    init(groupId: Int? = nil, groupName: String? = nil, intraId: Int? = nil, memberIntraName: String? = nil, grade: String? = nil, image: String? = nil, comment: String? = nil, inCluster: Bool? = nil, agree: Bool? = nil, defaultGroupId: Int? = nil, location: String? = nil) {
        self.groupId = groupId
        self.groupName = groupName
        self.intraId = intraId
        self.memberIntraName = memberIntraName
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

        self.groupId = (try? container.decodeIfPresent(Int.self, forKey: .groupId)) ?? 0
        self.groupName = (try? container.decodeIfPresent(String.self, forKey: .groupName)) ?? "nil"
        self.intraId = (try? container.decodeIfPresent(Int.self, forKey: .intraId)) ?? 0
        self.memberIntraName = (try? container.decodeIfPresent(String.self, forKey: .memberIntraName)) ?? "nil"
        self.grade = (try? container.decodeIfPresent(String.self, forKey: .grade)) ?? "nil"
        self.image = (try? container.decodeIfPresent(String.self, forKey: .image)) ?? "nil"
        self.comment = (try? container.decodeIfPresent(String.self, forKey: .comment)) ?? "nil"
        self.inCluster = (try? container.decodeIfPresent(Bool.self, forKey: .inCluster)) ?? false
        self.agree = (try? container.decodeIfPresent(Bool.self, forKey: .agree)) ?? false
        self.defaultGroupId = (try? container.decodeIfPresent(Int.self, forKey: .defaultGroupId)) ?? 0
        self.location = (try? container.decodeIfPresent(String.self, forKey: .location)) ?? "nil"
    }

    static var empty: GroupMemberInfo {
        GroupMemberInfo(intraId: 0, memberIntraName: "Name", grade: "4", image: "https://", comment: "Comment", inCluster: false)
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
