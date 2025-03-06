//
//  ReissueDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct ReissueDTO: Codable {
    var accessToken: String
}

struct ReissueRequestDTO: Codable {
    var intraId: String
}
