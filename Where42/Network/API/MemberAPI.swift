//
//  UserAPI.swift
//  Where42
//
//  Created by 현동호 on 11/28/23.
//

import SwiftUI

final class MemberAPI: API {
    static let shared = MemberAPI()
    
    func getMemberInfo() async throws -> MemberInfo? {
        var request = try await getURLRequest(subURL: "/member", needContentType: false, needAccessToken: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //            print(String(data: data, encoding: String.Encoding.utf8)!)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(MemberInfo.self, from: data)
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
        
        return nil
    }
    
    func updateComment(comment: String) async throws -> String? {
        var request = try await getURLRequest(subURL: "/member/comment", needContentType: true, needAccessToken: true, httpMethod: .post)

        guard let requestBody = try? JSONEncoder().encode(UpdateCommentDTO(comment: comment)) else {
            throw NetworkError.invalidRequestBody
        }
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(String(data: data, encoding: String.Encoding.utf8)!)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(MemberInfo.self, from: data).comment
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
        
        return nil
    }
    
    func deleteComment() async throws {
        var request = try await getURLRequest(subURL: "/member/comment", needContentType: false, needAccessToken: true, httpMethod: .delete)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200 ... 299:
            return
            
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
    }
    
    func updateCustomLocation(customLocation: String?) async throws -> String? {
        var request = try await getURLRequest(subURL: "/location/custom", needContentType: true, needAccessToken: true, httpMethod: .post)

        guard let requestBody = try? JSONEncoder().encode(UpdateCustomLocationDTO(customLocation: customLocation)) else {
            throw NetworkError.invalidRequestBody
        }
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        //            print(String(data: data, encoding: String.Encoding.utf8)!)
        
        switch response.statusCode {
        case 200 ... 299:
            return try JSONDecoder().decode(UpdateCustomLocationDTO.self, from: data).customLocation ?? "개포"
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
        
        return nil
    }
    
    func deleteCustomLocation() async throws -> Bool? {
        var request = try await getURLRequest(subURL: "/location/custom", needContentType: false, needAccessToken: true, httpMethod: .delete)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        //            print(String(data: data, encoding: String.Encoding.utf8)!)
        
        switch response.statusCode {
        case 200 ... 299:
            return true
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
        
        return nil
    }
    
    func search(keyWord: String) async throws -> [MemberInfo]? {
        print("----- search -----")
        var request = try await getURLRequest(subURL: "/search/new?keyWord=\(keyWord)", needContentType: false, needAccessToken: true)
        
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
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Unknown HTTP Response Status Code")
        }
        return nil
    }
}
