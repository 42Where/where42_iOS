//
//  LoginAPI.swift
//  Where42
//
//  Created by 현동호 on 1/9/24.
//

import SwiftUI

final class LoginAPI: API {
    static let shared = LoginAPI()

    func login() async throws {
        let request = try await getURLRequest(subURL: "/member", needContentType: false, needAccessToken: false)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return

        case 300...599:
            try await handleAPIError(response: response, data: data)

        default: print("Unknown HTTP Response Status Code")
        }
    }

    func join(intraId: String) async throws {
        var request = try await getURLRequest(subURL: "/join?intra_id=\(intraId)", needContentType: false, needAccessToken: true, httpMethod: .post)

        print(" J O I N ")
        print(intraId)
        try await print(API.sharedAPI.getAccessToken() as Any)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        if response.mimeType != "text/html" {
            print(String(data: data, encoding: .utf8)!)
        } else {
            print("token error")
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed join")
            DispatchQueue.main.async {
                MainViewModel.shared.isLogin = true
            }

        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed join")
        }
    }

    func logout() async throws {
        var request = try await getURLRequest(subURL: "/logout", needContentType: false, needAccessToken: true, httpMethod: .post)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed logout")

        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed logout")
        }
    }
}
