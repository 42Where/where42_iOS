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

    func join(intraId: String) async throws {
        guard let requestURL = URL(string: baseURL + "/join?intra_id=\(intraId)") else {
            return
        }

//        let intraIdQuery = URLQueryItem(name: "intra_id", value: intraId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue(LoginAPI.shared.accessToken, forHTTPHeaderField: "Authorization")

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
                    DispatchQueue.main.async {
                        MainViewModel.shared.isLogin = false
                    }
                    throw NetworkError.Token
                } else {
                    print("Succeed join")
                    DispatchQueue.main.async {
                        MainViewModel.shared.isLogin = true
                    }
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
        } catch NetworkError.Reissue {
            throw NetworkError.Reissue
        } catch {}
    }

    func logout() async throws {
        guard let requsetURL = URL(string: baseURL + "/logout") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requsetURL)
        request.httpMethod = "POST"
        request.addValue(API.sharedAPI.accessToken, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

//            print(String(data: data, encoding: .utf8))

            switch response.statusCode {
            case 200 ... 299:
                if response.mimeType == "text/html" {
                    throw NetworkError.Token
                } else {
                    print("Succeed logout")
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
                print("Failed logout")
            }
        } catch {}
    }
}
