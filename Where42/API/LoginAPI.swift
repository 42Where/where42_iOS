//
//  LoginAPI.swift
//  Where42
//
//  Created by 현동호 on 1/9/24.
//

import SwiftUI

struct joinDTO: Codable {
    var accessToken: String
}

class LoginAPI: API {
    static let shared = LoginAPI()

    func login() async throws {
        guard let requestURL = URL(string: baseURL + "/member") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return

        case 300 ... 399:
            throw NetworkError.BadRequest

        case 400 ... 499:
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

        case 500 ... 599:
            throw NetworkError.ServerError

        default: print("Unknown HTTP Response Status Code")
        }
    }

    func join(intraId: String) async throws {
        guard let requestURL = URL(string: baseURL + "/join?intra_id=\(intraId)") else {
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

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

        case 400 ... 499:
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
        case 500 ... 599:
            throw NetworkError.ServerError
        default:
            print("Failed join")
        }
    }

    func logout() async throws {
        guard let requsetURL = URL(string: baseURL + "/logout") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requsetURL)
        request.httpMethod = "POST"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8))

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed logout")

        case 400 ... 499:
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
        case 500 ... 599:
            throw NetworkError.ServerError
        default:
            print("Failed logout")
        }
    }
}
