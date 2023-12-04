//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import Foundation

struct MemberUpdateDTO: Codable {
    var intraId: Int
    var comment: String?
    var customLocation: String?
}

class MemberAPI: API {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""

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

            if response.statusCode == 200 {
                return try JSONDecoder().decode(MemberInfo.self, from: data)
            } else {
                throw NetworkError.invalidHTTPResponse
            }
        } catch {
            print("Error fetching UserInfo: \(error)")
            throw error
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

            if response.statusCode == 200 {
                print("Success")
                return try JSONDecoder().decode(MemberInfo.self, from: data).comment
            } else {
                print("Failure \(response.statusCode)")
                return nil
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

            if response.statusCode == 200 {
                print("Success")
                return try JSONDecoder().decode(MemberInfo.self, from: data).customLocation
            } else {
                fatalError("Failed Request")
            }
        } catch {
            fatalError("Error Update Custom Location \(error)")
        }
    }
}
