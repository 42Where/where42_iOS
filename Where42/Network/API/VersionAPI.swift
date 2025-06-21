//
//  VersionAPI.swift
//  Where42
//
//  Created by 이창현 on 9/11/24.
//

import SwiftUI

final class VersionAPI: API {

    func checkUpdateNeeded() async throws {
        var request = try await getURLRequest(subURL: "/version", needContentType: true, needAccessToken: true, httpMethod: .post)

        let verStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        print("VERSION : \(verStr)")
        guard let requestBody = try?JSONEncoder().encode(VersionDTO(os: "ios", version: verStr)) else {
            print("Failed Create VersionAPI Request Body")
            throw NetworkError.invalidRequestBody
        }
        request.httpBody = requestBody

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
