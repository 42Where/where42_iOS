//
//  GroupAPI.swift
//  Where42
//
//  Created by 현동호 on 12/5/23.
//

import SwiftUI

struct CreateGroupDTO: Codable {
    var groupName: String
}

struct UpdateGroupDTO: Codable {
    var groupId: Int
    var groupName: String
}

struct UpdateGroupMemberDTO: Codable {
    var groupId: Int
    var members: [Int]
}

struct AddOneGroupMemberDTO: Codable {
    var intraId: Int
    var groupId: Int
}

class GroupAPI: API {
    static let shared = GroupAPI()

    func createGroup(groupName: String) async throws -> Int? {
        guard let requestBody = try? JSONEncoder().encode(CreateGroupDTO(groupName: groupName)) else {
            print("Failed Create Request Body")
            return nil
        }

        guard let requestURL = URL(string: baseURL + "/group") else {
            print("Missing URL")
            return nil
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

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Success")
            return try JSONDecoder().decode(UpdateGroupDTO.self, from: data).groupId

        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    try await API.sharedAPI.reissue()
                    throw NetworkError.Reissue
//                        return nil
                }
            } else {
                throw NetworkError.BadRequest
            }
        case 500 ... 599:
            throw NetworkError.ServerError
        default:
            print("Failed Create Group")
        }

        return nil
    }

    func getGroup() async throws -> [GroupInfo]? {
        guard let requestURL = URL(string: baseURL + "/group") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed get group")
            return try JSONDecoder().decode([GroupInfo].self, from: data)

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
            print("Failed Get Groups")
        }

        return nil
    }

    func updateGroupName(groupId: Int, newGroupName: String) async throws -> String? {
        guard let requestBody = try? JSONEncoder().encode(UpdateGroupDTO(groupId: groupId, groupName: newGroupName)) else {
            print("Failed Create request Body")
            throw NetworkError.invalidURL
        }

        guard let requestURL = URL(string: baseURL + "/group/name") else {
            print("Missing Error")
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

        print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed update group name")
            return try JSONDecoder().decode(UpdateGroupDTO.self, from: data).groupName

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
            print("Failed update Group name")
        }

        return nil
    }

    func deleteGroup(groupId: Int) async throws -> Bool {
        guard let requestURL = URL(string: baseURL + "/group?groupId=\(groupId)") else {
            print("Failed encode requestURL")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.addValue("applicaion/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed delete group")
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
        default:
            print("Failed delete group")
        }

        return false
    }

    func deleteGroupMember(groupId: Int, members: [MemberInfo]) async throws -> Bool {
        let membersIntraId: [Int] = members.map { $0.intraId }

        guard let requestBody = try? JSONEncoder().encode(UpdateGroupMemberDTO(groupId: groupId, members: membersIntraId)) else {
            print("Failed create request Body")
            throw NetworkError.invalidRequestBody
        }

        guard let requestURL = URL(string: baseURL + "/group/groupmember") else {
            print("Failed create URL")
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed delete group")
            return true

        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    try await API.sharedAPI.reissue()
                    throw NetworkError.Reissue
//                        return false
                }
            } else {
                throw NetworkError.BadRequest
            }
        case 500 ... 599:
            throw NetworkError.ServerError
        default:
            print("Failed delete group")
        }

        return false
    }

    func addMembers(groupId: Int, members: [MemberInfo]) async throws -> Bool {
        let members: [Int] = members.map { $0.intraId }

        guard let requsetBody = try? JSONEncoder().encode(UpdateGroupMemberDTO(groupId: groupId, members: members)) else {
            print("failed create requset body")
            return false
        }

        guard let requestURL = URL(string: baseURL + "/group/groupmember/members") else {
            print("failed create requset URL")
            return false
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = requsetBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed add members")
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
        default:
            print("Failed add members")
        }

        return false
    }

    func getNotInGorupMember(groupId: Int) async throws -> [MemberInfo]? {
        guard let requestURL = URL(string: baseURL + "/group/groupmember/not-ingroup?groupId=\(groupId)") else {
            return nil
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed get not in group members")
            return try JSONDecoder().decode([MemberInfo].self, from: data)

        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    try await API.sharedAPI.reissue()
                    throw NetworkError.Reissue
//                        return nil
                }
            } else {
                throw NetworkError.BadRequest
            }
        case 500 ... 599:
            throw NetworkError.ServerError
        default:
            print("Failed add members")
        }

        return nil
    }
    
    func addFriend(intraId: Int) async throws -> Bool {

        guard let requestURL = URL(string: baseURL + "/group/groupmember?intraId=\(intraId)") else {
            print("Failed create URL")
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
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
        default:
            print("Failed add friend")
            return false
        }
        return false
    }
}
