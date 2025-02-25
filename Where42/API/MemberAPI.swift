//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import SwiftUI

struct CreateMemberDTO: Codable {
    var intraId: Int
    var intraName: String?
    var grade: Int?
    var image: String?
}

struct UpdateCommentDTO: Codable {
    var comment: String?
}

struct UpdateCustomLocationDTO: Codable {
    var customLocation: String?
}

struct DeleteMemberDTO: Codable {
    var intraId: Int
}

final class MemberAPI: API {
    static let shared = MemberAPI()

    func getMemberInfo() async throws -> MemberInfo? {
        guard let requestURL = URL(string: baseURL + "/member") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        try await print("getMemberInfo token: ", API.sharedAPI.getAccessToken())

        let (data, response) = try await URLSession.shared.data(for: request)

//            print(String(data: data, encoding: String.Encoding.utf8)!)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(MemberInfo.self, from: data)

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

        return nil
    }

    func updateComment(comment: String) async throws -> String? {
        guard let requestBody = try? JSONEncoder().encode(UpdateCommentDTO(comment: comment)) else {
            throw NetworkError.invalidRequestBody
        }

        guard let requestURL = URL(string: baseURL + "/member/comment") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        print(String(data: data, encoding: String.Encoding.utf8)!)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(MemberInfo.self, from: data).comment

        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    try await API.sharedAPI.reissue()
                    throw NetworkError.Reissue
//                        return requestURL.absoluteString
                }
            } else {
                throw NetworkError.BadRequest
            }

        case 500 ... 599:
            throw NetworkError.ServerError

        default: print("Unknown HTTP Response Status Code")
        }

        return nil
    }

    func deleteComment() async throws {
        guard let requestURL = URL(string: baseURL + "/member/comment") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            return

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

    func updateCustomLocation(customLocation: String?) async throws -> String? {
        guard let requestBody = try? JSONEncoder().encode(UpdateCustomLocationDTO(customLocation: customLocation)) else {
            throw NetworkError.invalidRequestBody
        }

        guard let requestURL = URL(string: baseURL + "/location/custom") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: String.Encoding.utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(UpdateCustomLocationDTO.self, from: data).customLocation ?? "개포"

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

        return nil
    }

    func deleteCustomLocation() async throws -> Bool? {
        guard let requestURL = URL(string: baseURL + "/location/custom") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: String.Encoding.utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            return true

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

        return nil
    }

    func search(keyWord: String) async throws -> [MemberInfo]? {
        print("----- search -----")
        guard let requestURL = URL(string: baseURL + "/search/new?keyWord=\(keyWord)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        if response.statusCode == 500 {
            print(String(data: data, encoding: String.Encoding.utf8)!)
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed search member")
            return try JSONDecoder().decode([MemberInfo].self, from: data)

        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    print(keyWord)
                    if customException.errorCode != 1300 && customException.errorCode != 1301 {
                        try await API.sharedAPI.reissue()
                        throw NetworkError.Reissue
                    }
                }
            } else {
                throw NetworkError.BadRequest
            }

        case 500 ... 599:
            throw NetworkError.ServerError

        default: print("Unknown HTTP Response Status Code")
        }

        return nil
    }
}
