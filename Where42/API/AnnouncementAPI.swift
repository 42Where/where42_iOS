//
//  AnnouncementAPI.swift
//  Where42
//
//  Created by 이창현 on 11/20/24.
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

final class AnnouncementAPI: API {
  
  static let shared = AnnouncementAPI()
  
  var announcementList: [Announcement] = []
  
  func getAnnouncementList() async throws -> [Announcement] {

    guard let requestURL = URL(string: baseURL + "/announcement?page=0&size=5") else {
      throw NetworkError.invalidURL
    }

    var request = URLRequest(url: requestURL)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let response = response as? HTTPURLResponse else {
      throw NetworkError.invalidHTTPResponse
    }

    switch response.statusCode {
      
    case 200...299:
      let decodedResponse = try JSONDecoder().decode(ResponseAnnouncementsDTO.self, from: data)
      let receivedAnnouncements = decodedResponse.announcements
      if receivedAnnouncements.isEmpty { return announcementList }
      
      if !announcementList.isEmpty {
        self.announcementList.removeAll()
      }
      
      for i in 0..<receivedAnnouncements.count {
        let newAnnouncement = Announcement(
          id: receivedAnnouncements[i].announcementId,
          title: receivedAnnouncements[i].title, 
          content: receivedAnnouncements[i].content,
          authorName: receivedAnnouncements[i].authorName,
          createAt: receivedAnnouncements[i].createAt,
          updateAt: receivedAnnouncements[i].updateAt
        )
        self.announcementList.append(newAnnouncement)
      }
      
      return announcementList
      
    case 300...399:
      throw NetworkError.BadRequest
      
    case 400...499:
      let response = String(data: data, encoding: String.Encoding.utf8)!
      if response.contains("errorCode") && response.contains("errorMessage") {
        let customException = parseCustomException(response: response)
        if customException.handleError() == false {
          try await API.sharedAPI.reissue()
          throw NetworkError.Reissue
        }
      } else {
        throw NetworkError.BadRequest
      }
      
    case 500...599:
      throw NetworkError.ServerError
      
    default: print("Failed Requesting Recent Version")
      
    }
    return announcementList
  }
  
}
