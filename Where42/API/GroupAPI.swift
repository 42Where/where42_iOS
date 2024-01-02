//
//  GroupAPI.swift
//  Where42
//
//  Created by 현동호 on 12/5/23.
//

import Foundation

struct CreateGroupDTO: Codable {
    var intraId: Int
    var groupName: String
}

struct UpdateGroupDTO: Codable {
    var groupId: Int
    var groupName: String
}

struct DeleteGroupMemberDTO: Codable {
    var groupId: Int
    var members: [Int]
}

struct AddOneGroupMemberDTO: Codable {
    var intraId: Int
    var groupId: Int
    var groupName: String
    var owner: Bool = false
    var isOwner: Bool = false
}

struct AddGroupMembersDTO: Codable {
    var groupId: Int
    var members: [String]
}

class GroupAPI: API {
    func createGroup(intraId: Int, groupName: String) async throws -> Int? {
        guard let requestBody = try? JSONEncoder().encode(CreateGroupDTO(intraId: intraId, groupName: groupName)) else {
            fatalError("Failed Create Request Body")
        }

        guard let requestURL = URL(string: baseURL + "/group") else {
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

            print("response statusCode", response.statusCode)

            switch response.statusCode {
            case 200 ... 299:
                print("Success")
                return try JSONDecoder().decode(UpdateGroupDTO.self, from: data).groupId
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
        return nil
    }

    func getGroup(intraId: Int) async throws -> [GroupInfo] {
        guard let requestURL = URL(string: baseURL + "/group?intraId=\(intraId)") else {
            fatalError("Missing URL")
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: requestURL)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

//            print(String(data: data, encoding: .utf8)!)

            switch response.statusCode {
            case 200 ... 299:
                print("Succeed get group")
                return try JSONDecoder().decode([GroupInfo].self, from: data)
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed Get Groups")
            }
        } catch {
            print(error)
            errorPrint(error, message: "Failed Get Groups")
            fatalError()
        }
    }

    func updateGroupName(groupId: Int, newGroupName: String) async throws -> String {
        guard let requestBody = try? JSONEncoder().encode(UpdateGroupDTO(groupId: groupId, groupName: newGroupName)) else {
            fatalError("Failed Create request Body")
        }

        guard let requestURL = URL(string: baseURL + "/group/name") else {
            fatalError("Missing Error")
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

//            print(String(data: data, encoding: .utf8)!)

            switch response.statusCode {
            case 200 ... 299:
                print("Succeed update group name")
                return try JSONDecoder().decode(UpdateGroupDTO.self, from: data).groupName
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed update Group name")
            }

        } catch {
            errorPrint(error, message: "Failed update group name")
            fatalError()
        }
    }

    func deleteGroup(groupId: Int, groupName: String) async throws -> Bool {
        guard let requestBody = try? JSONEncoder().encode(UpdateGroupDTO(groupId: groupId, groupName: groupName)) else {
            fatalError("Failed encode requestBody")
        }

        guard let requestURL = URL(string: baseURL + "/group?groupId=\(groupId)") else {
            fatalError("Failed encode requestBody")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.addValue("applicaion/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

//            print(String(data: data, encoding: .utf8)!)

            switch response.statusCode {
            case 200 ... 299:
                print("Succeed delete group")
                return true
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed delete group")
            }
        } catch {
            errorPrint(error, message: "Failed delete group")
            return false
        }
    }

    func deleteGroupMember(groupId: Int, members: [GroupMemberInfo]) async throws -> Bool {
        let membersIntraId: [Int] = members.map { $0.intraId! }

        guard let requestBody = try? JSONEncoder().encode(DeleteGroupMemberDTO(groupId: groupId, members: membersIntraId)) else {
            fatalError("Failed create request Body")
        }

        guard let requestURL = URL(string: baseURL + "/group/groupmember") else { fatalError("Failed create URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody

        do {
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
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed delete group")
            }
        } catch {
            errorPrint(error, message: "Failed delete group member")
            return false
        }
    }

    func addMembers(groupId: Int, members: [GroupMemberInfo]) async {
        let members: [String] = members.map { $0.memberIntraName! }

        guard let requsetBody = try? JSONEncoder().encode(AddGroupMembersDTO(groupId: groupId, members: members)) else {
            fatalError("failed create requset body")
        }

        guard let requestURL = URL(string: baseURL + "/group/groupmember/members") else {
            fatalError("failed create requset URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = requsetBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

//            print(String(data: data, encoding: .utf8)!)

            switch response.statusCode {
            case 200 ... 299:
                print("Succeed add members")
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed add members")
            }
        } catch {
            errorPrint(error, message: "Failed add members")
        }
    }

    func addOneMember(groupId: Int, groupName: String, intraId: Int) async {
        guard let requsetBody = try? JSONEncoder().encode(AddOneGroupMemberDTO(intraId: intraId, groupId: groupId, groupName: groupName)) else {
            fatalError("failed create requset body")
        }

        guard let requestURL = URL(string: baseURL + "/group/groupmember/members") else {
            fatalError("failed create requset URL")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = requsetBody

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

//            print(String(data: data, encoding: .utf8)!)

            switch response.statusCode {
            case 200 ... 299:
                print("Succeed add one member")
            case 400 ... 499:
                throw NetworkError.BadRequest
            case 500 ... 599:
                throw NetworkError.ServerError
            default:
                fatalError("Failed add one member")
            }
        } catch {
            errorPrint(error, message: "Failed add one member")
        }
    }
}
