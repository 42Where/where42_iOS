//
//  StatDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct SingleClusterUsage: Codable {
    // MARK: - Properties
    var name: String
    var usageRate: Int
    var usingImacCount: Int
    var totalImacCount: Int
    
    // MARK: - Initializers
    init(name: String, usageRate: Int, usingImacCount: Int, totalImacCount: Int) {
        self.name = name
        self.usageRate = usageRate
        self.usingImacCount = usingImacCount
        self.totalImacCount = totalImacCount
    }
    
    init(name: String) {
        self.name = name
        self.usageRate = 0
        self.usingImacCount = 0
        self.totalImacCount = 0
    }
}
struct ClusterUsageDTO: Codable {
    var clusters: [SingleClusterUsage]
}

struct IMacUsageDTO: Codable {
    var usageRate: Int
    var usingImacUserCount: Int
    var totalUserCount: Int
}

struct SingleUserSeatHistory: Codable {
    var seat: String
    var usingTimeHour: Int
    var usingTimeMinute: Int
    var usingTimeSecond: Int
    var usingCount: Int
}
struct UserSeatHistoryDTO: Codable {
    var seats: [SingleUserSeatHistory]
}

struct SinglePopularIMac: Codable {
    var seat: String
    var usingTimeHour: Int
    var usingTimeMinute: Int
    var usingTimeSecond: Int
    var usingUserCount: Int
}
struct PopularIMacDTO: Codable {
    var seats: [SinglePopularIMac]
}
