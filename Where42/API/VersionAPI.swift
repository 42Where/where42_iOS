//
//  VersionAPI.swift
//  Where42
//
//  Created by 이창현 on 9/11/24.
//

import SwiftUI

struct VersionDTO: Encodable {
    var os: String
    var version: String
}

struct CheckVersionDTO: Codable {
    var version: String
}

class VersionAPI: API {
//    static let shared = VersionAPI()

    func checkUpdateNeeded() async throws {
        guard let requestURL = URL(string: baseURL + "/version") else {
            throw NetworkError.invalidURL
        }
        
        guard let requestBody = try?JSONEncoder().encode(VersionDTO(os: "ios", version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)) else {
            print("Failed Create VersionAPI Request Body")
            throw NetworkError.invalidRequestBody
        }

//        print(requestURL.absoluteString)

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        print("VERSION : ")
        print(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200...299:
            print(try JSONDecoder().decode(CheckVersionDTO.self, from: data))
            return

        case 300...399:
            throw NetworkError.BadRequest

        case 400...499:
            if response.statusCode == 426 {
                throw NetworkError.VersionUpdate
            } else {
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
            }

        case 500...599:
            throw NetworkError.ServerError

        default: print("Failed Requesting Recent Version")
        }
    } 
}
