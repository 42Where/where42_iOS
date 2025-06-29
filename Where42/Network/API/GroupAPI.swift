//
//  GroupAPI.swift
//  Where42
//
//  Created by 현동호 on 12/5/23.
//

import SwiftUI

final class GroupAPI: API {
    static let shared = GroupAPI()

    func createGroup(groupName: String) async throws -> Int? {
        var request = try await getURLRequest(subURL: "/group", needContentType: true, needAccessToken: true, httpMethod: .post)
        
        guard let requestBody = try? JSONEncoder().encode(CreateGroupDTO(groupName: groupName)) else {
            print("Failed Create Request Body")
            return nil
        }

        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Success")
            return try JSONDecoder().decode(UpdateGroupDTO.self, from: data).groupId

        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed Create Group")
        }

        return nil
    }

    func getGroup() async throws -> [GroupInfo]? {
        let request = try await getURLRequest(subURL: "/group", needContentType: false, needAccessToken: true)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

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
        var request = try await getURLRequest(subURL: "/group/name", needContentType: true, needAccessToken: true, httpMethod: .post)
        
        guard let requestBody = try? JSONEncoder().encode(UpdateGroupDTO(groupId: groupId, groupName: newGroupName)) else {
            print("Failed Create request Body")
            throw NetworkError.invalidURL
        }

        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

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
        let request = try await getURLRequest(subURL: "/group?groupId=\(groupId)", needContentType: true, needAccessToken: true, httpMethod: .delete)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed delete group")
            return true
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed delete group")
        }

        return false
    }

    func deleteGroupMember(groupId: Int, members: [MemberInfo]) async throws -> Bool {
        var request = try await getURLRequest(subURL: "/group/groupmember", needContentType: true, needAccessToken: true, httpMethod: .put)
        
        let membersIntraId: [Int] = members.map { $0.intraId }
        guard let requestBody = try? JSONEncoder().encode(UpdateGroupMemberDTO(groupId: groupId, members: membersIntraId)) else {
            print("Failed create request Body")
            throw NetworkError.invalidRequestBody
        }

        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed delete group")
            return true
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed delete group")
        }

        return false
    }

    func addMembers(groupId: Int, members: [MemberInfo]) async throws -> Bool {
        var request = try await getURLRequest(subURL: "/group/groupmember/members", needContentType: true, needAccessToken: true, httpMethod: .post)
        
        let members: [Int] = members.map { $0.intraId }
        guard let requsetBody = try? JSONEncoder().encode(UpdateGroupMemberDTO(groupId: groupId, members: members)) else {
            print("failed create requset body")
            return false
        }

        request.httpBody = requsetBody

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed add members")
            return true

        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed add members")
        }

        return false
    }

    func getNotInGroupMember(groupId: Int) async throws -> [MemberInfo]? {
        let request = try await getURLRequest(subURL: "/group/groupmember/not-ingroup?groupId=\(groupId)", needContentType: false, needAccessToken: true, httpMethod: .post)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }

//            print(String(data: data, encoding: .utf8)!)

        switch response.statusCode {
        case 200 ... 299:
            print("Succeed get not in group members")
            return try JSONDecoder().decode([MemberInfo].self, from: data)

        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed add members")
        }

        return nil
    }
    
    func addFriend(intraId: Int) async throws -> Bool {
        let request = try await getURLRequest(subURL: "/group/groupmember?intraId=\(intraId)", needContentType: true, needAccessToken: true, httpMethod: .post)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200 ... 299:
            return true
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed add friend")
            return false
        }
        return false
    }
}
