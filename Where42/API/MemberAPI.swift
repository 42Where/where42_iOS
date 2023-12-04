//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import Foundation

class UserAPI: API {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""

    func getMemberInfo(intraId: Int) async throws -> MemberInfo {
        print("getUserInfo")
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

//            if response.statusCode == 200 {
            return try JSONDecoder().decode(MemberInfo.self, from: data)
//            } else {
//                throw NetworkError.invalidHTTPResponse
//            }
        } catch {
            print("Error fetching UserInfo: \(error)")
            throw error
        }
    }
}
