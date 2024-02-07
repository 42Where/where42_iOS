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

    override private init() {}
//    func login() async throws -> {
//        guard let requestURL = URL(string: baseURL + "") else {
//            throw NetworkError.invalidURL
//        }
//
//        do {
//            let (data, response) = try await URLSession.shared.data(from: requestURL)
//
//            guard let response = response as? HTTPURLResponse else {
//                throw NetworkError.invalidHTTPResponse
//            }
//        } catch {
//            print(error)
//            errorPrint(error, message: "Failed Login")
//            print()
//        }
//    }

    func join(intraId: String) async {
        guard let requestURL = URL(string: baseURL + "/join?intra_id=\(intraId)") else {
            return
        }

//        let intraIdQuery = URLQueryItem(name: "intra_id", value: intraId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue(LoginAPI.sharedAPI.accessToken, forHTTPHeaderField: "Authorization")

        print(" J O I N ")
        print(intraId)
        print(accessToken)

        do {
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
                if response.mimeType == "text/html" {
                    isLogin = false
                    throw NetworkError.Token
                } else {
                    print("Succeed join")
                    isLogin = true
                }
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                print("Failed join")
            }
        } catch {}
    }
}
