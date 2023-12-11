//
//  GroupAPI.swift
//  Where42
//
//  Created by 현동호 on 12/5/23.
//

import Foundation

struct CreateGroupDTO: Codable {
    var memberIntraId: Int
    var groupName: String
}

class GroupAPI: API {
    func createGroup(intraId: Int, groupName: String) async {
        guard let requestBody = try? JSONEncoder().encode(CreateGroupDTO(memberIntraId: intraId, groupName: groupName)) else {
            fatalError("Failed Create Request Body")
        }

        guard let requestURL = URL(string: baseURL + "/group/") else {
            fatalError("Missing URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            switch response.statusCode {
            case 200 ... 299:
                print("Success")
                return
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed Create Group")
            }
        } catch {
            errorPrint(error, message: "Failed Create Group")
        }
    }

    func getGroup(intraId: Int) async throws -> GroupInfo {
        guard let requestURL = URL(string: baseURL + "/group/?memberId=\(intraId)") else {
            fatalError("Missing URL")
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: requestURL)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            print(String(data: data, encoding: .utf8))

            switch response.statusCode {
            case 200 ... 299:
                print("Success")
                return try JSONDecoder().decode(GroupInfo.self, from: data)
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed Get Groups")
            }
        } catch {
            errorPrint(error, message: "Failed Get Groups")
            fatalError()
        }
    }
}
