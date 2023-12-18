//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import Foundation

struct CreateMemberDTO: Codable {
    var intraId: Int
    var intraName: String?
    var grade: Int?
    var image: String?
}

struct UpdateCommentDTO: Codable {
    var intraId: Int
    var comment: String?
}

struct UpdateCustomLocationDTO: Codable {
    var intraId: Int
    var customLocation: String?
}

struct ResponseCustomLocationDTO: Codable {
    var intraId: Int
    var imacLocation: String
    var customLocation: String
}

struct DeleteMemberDTO: Codable {
    var intraId: Int
}

class MemberAPI: API {
    func createMember(memberCreateDTO: CreateMemberDTO) async throws -> MemberInfo {
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

    func getMemberInfo(intraId: Int) async throws -> (MemberInfo?, URL?) {
        guard let requestURL = URL(string: baseURL + "/member?intraId=\(intraId)") else {
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
                if response.mimeType == "text/html" {
                    print(requestURL)
                    return (nil, requestURL)
                } else {
                    return try (JSONDecoder().decode(MemberInfo.self, from: data), nil)
                }

            case 300 ... 399:
                print("Redirect")
                throw NetworkError.BadRequest

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
        let requestBody = try! JSONEncoder().encode(DeleteMemberDTO(intraId: intraId))

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
        let requestBody = try! JSONEncoder().encode(UpdateCommentDTO(intraId: intraId, comment: statusMessage))
        print(String(data: requestBody, encoding: String.Encoding.utf8)!)

        guard let requestURL = URL(string: baseURL + "/member/comment") else {
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
        let requestBody = try! JSONEncoder().encode(UpdateCustomLocationDTO(intraId: intraId, customLocation: customLocation))

        guard let requestURL = URL(string: baseURL + "/location/custom") else {
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
                print("Succeed update Custom Location")
                return try JSONDecoder().decode(ResponseCustomLocationDTO.self, from: data).customLocation
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
