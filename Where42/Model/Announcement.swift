//
//  Announcement.swift
//  Where42
//
//  Created by 이창현 on 11/20/24.
//

import Foundation

struct Announcement: Identifiable {

  var id: Int64
  var title: String
  var content: String
  var authorName: String
  var createAt: String
  var updateAt: String

  init(id: Int64, title: String, content: String, authorName: String, createAt: String, updateAt: String) {
    self.title = title
    self.content = content
    self.authorName = authorName
    self.createAt = createAt
    self.updateAt = updateAt
    self.id = id
  }
}

extension Announcement {
  static let sampleData: [Announcement] = [
    Announcement(id: 1, title: "버그 픽스", content: "테스트 공지 1입니다.", authorName: "steve", createAt: "2024-11-20", updateAt: "2024-11-20"),
    Announcement(id: 2, title: "버그 픽스", content: "테스트 공지 2입니다.", authorName: "Kim", createAt: "2023-11-20", updateAt: "2023-11-20"),
    Announcement(id: 3, title: "새 기능", content: "테스트 공지 3입니다.", authorName: "Alex", createAt: "2021-02-29", updateAt: "2024-11-11"),
    Announcement(id: 4, title: "이벤트", content: "테스트 공지 4입니다.", authorName: "David", createAt: "2023-12-11", updateAt: "2024-01-01"),
    Announcement(id: 5, title: "TEST", content: "TEST", authorName: "tester", createAt: "1997-12-31", updateAt: "1998-01-01")
  ]
  
}
