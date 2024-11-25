//
//  AnnouncementAPI.swift
//  Where42
//
//  Created by 이창현 on 11/20/24.
//

import Foundation

struct ResponseAnnouncementDTO: Codable {
  var announcementId: Int64
  var title: String
  var content: String
  var authorName: String
  var createAt: String
  var updateAt: String
}

class AnnouncementAPI: API {
  static let shared = AnnouncementAPI()

  func getAnnouncementList() async throws -> [Announcement] {

    var announcementList = Array(repeating: Announcement(), count: 5)

    for i in 1...5 {
      guard let requestURL = URL(string: baseURL + "/announcement?page=\(i)") else {
        throw NetworkError.invalidURL
      }

      var request = URLRequest(url: requestURL)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

      let (data, response) = try await URLSession.shared.data(for: request)

      guard let response = response as? HTTPURLResponse else {
        throw NetworkError.invalidHTTPResponse
      }

      switch response.statusCode {

      case 200...299:
        let decodedResponse = try JSONDecoder().decode(ResponseAnnouncementDTO.self, from: data)
        announcementList[i - 1].id = decodedResponse.announcementId
        announcementList[i - 1].title = decodedResponse.title
        announcementList[i - 1].content = decodedResponse.content
        announcementList[i - 1].authorName = decodedResponse.authorName
        announcementList[i - 1].createAt = decodedResponse.createAt
        announcementList[i - 1].updateAt = decodedResponse.updateAt

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
    }
    return announcementList
  }

}
