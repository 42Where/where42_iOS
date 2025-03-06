//
//  AnnouncementDTO.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

struct ResponseAnnouncementsDTO: Decodable {
  var announcements: [AnnouncementDTO]
  var totalPages: Int
  var totalElements: Int
}

struct AnnouncementDTO: Decodable {
  var announcementId: Int64
  var title: String
  var content: String
  var authorName: String
  var createAt: String
  var updateAt: String
}
