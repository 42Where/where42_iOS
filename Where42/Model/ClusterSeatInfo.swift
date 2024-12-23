//
//  ClusterMemberInfo.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

struct ClusterSeatInfo: Identifiable {
    var id: Int = -1
    var isLoggedIn: Bool = false
    var intraName: String = ""
    var image: String = ""
    var cluster: String = ""
    var row: Int = -1
    var seat: Int = -1
    var isFriend: Bool = false
}
