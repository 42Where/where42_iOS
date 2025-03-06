//
//  VersionDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct VersionDTO: Encodable {
    var os: String
    var version: String
}

struct CheckVersionDTO: Codable {
    var version: String
}
