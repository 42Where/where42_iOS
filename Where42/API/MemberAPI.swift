//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import Foundation

struct MemberCreateDTO: Codable {
    var intraId: Int
    var intraName: String?
    var grade: Int?
    var image: String?
}

struct MemberUpdateDTO: Codable {
    var intraId: Int
    var comment: String?
    var customLocation: String?
}

struct MemberDeleteDTO: Codable {
    var intraId: Int
}

class MemberAPI: API {
    func createMember(memberCreateDTO: MemberCreateDTO) async throws -> MemberInfo {
        let requestBody = try! JSONEncoder().encode(memberCreateDTO)

        guard let requestURL = URL(string: baseURL + "/member/") else {
            fatalError("Missing URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                return try JSONDecoder().decode(MemberInfo.self, from: data)

            case 400 ... 499:
                throw NetworkError.BadRequest

            case 500 ... 599:
                throw NetworkError.ServerError

            default: fatalError("Unknown HTTP Response Status Code")
            }
        } catch {
            fatalError("Failed create Member")
        }
    }

    func getMemberInfo(intraId: Int) async throws -> MemberInfo {
        guard let requestURL = URL(string: baseURL + "/member/?intraId=\(intraId)") else {
            print("Missing URL")
            fatalError("Missing URL")
        }

//        let urlRequest = URLRequest(url: requestURL, method: .get)

//        print(requestURL)
        do {
            let (data, response) = try await URLSession.shared.data(from: requestURL)

//            print(String(data: data, encoding: String.Encoding.utf8)!)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                return try JSONDecoder().decode(MemberInfo.self, from: data)

            case 400 ... 499:
                throw NetworkError.BadRequest

            case 500 ... 599:
                throw NetworkError.ServerError

            default: fatalError("Unknown HTTP Response Status Code")
            }
        } catch {
            print("Error fetching UserInfo: \(error)")
            throw error
        }
    }

    func deleteMember(intraId: Int) async throws -> Bool {
        let requestBody = try! JSONEncoder().encode(MemberDeleteDTO(intraId: intraId))

        guard let requestURL = URL(string: baseURL + "/member/") else {
            fatalError("Missing URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                return true

            case 400 ... 499:
                throw NetworkError.BadRequest

            case 500 ... 599:
                throw NetworkError.ServerError

            default: fatalError("Unknown HTTP Response Status Code")
            }
        } catch {
            fatalError("Failed Delete Member")
        }
    }

    func updateStatusMessage(intraId: Int, statusMessage: String) async throws -> String? {
        let requestBody = try! JSONEncoder().encode(MemberUpdateDTO(intraId: intraId, comment: statusMessage))
        print(String(data: requestBody, encoding: String.Encoding.utf8)!)

        guard let requestURL = URL(string: baseURL + "/member/comment") else {
            print("Missing URL")
            fatalError("Missing URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            print(String(data: data, encoding: String.Encoding.utf8)!)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                return try JSONDecoder().decode(MemberInfo.self, from: data).comment

            case 400 ... 499:
                throw NetworkError.BadRequest

            case 500 ... 599:
                throw NetworkError.ServerError

            default: fatalError("Unknown HTTP Response Status Code")
            }
        } catch {
            print("Error Update Comment \(error)")
            return nil
        }
    }

    func updateCustomLocation(intraId: Int, customLocation: String) async throws -> String? {
        let requestBody = try! JSONEncoder().encode(MemberUpdateDTO(intraId: intraId, customLocation: customLocation))

        guard let requestURL = URL(string: baseURL + "/member/custom-location") else {
            fatalError("Missing URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                print("Success")
                return try JSONDecoder().decode(MemberInfo.self, from: data).customLocation
            case 400 ... 499:
                throw NetworkError.BadRequest

            case 500 ... 599:
                throw NetworkError.ServerError

            default: fatalError("Unknown HTTP Response Status Code")
            }
        } catch {
            fatalError("Error Update Custom Location \(error)")
        }
    }
}
