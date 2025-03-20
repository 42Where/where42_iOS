//
//  VersionAPI.swift
//  Where42
//
//  Created by 이창현 on 9/11/24.
//

import SwiftUI

final class VersionAPI: API {
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
        case 426:
            throw NetworkError.VersionUpdate
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Failed Requesting Recent Version")
        }
    } 
}
