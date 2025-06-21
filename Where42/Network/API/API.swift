//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

class API {
    // MARK: - Properties
    static let sharedAPI = API()
    
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    @AppStorage("intraId") var intraId: Int = 0
    
    // MARK: - Methods
    func getURLRequest(subURL: String,
                       needContentType: Bool,
                       needAccessToken: Bool,
                       httpMethod: HTTPMethods = .get) async throws -> URLRequest {
        guard let requestURL = URL(string: baseURL + subURL) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        
        if needContentType {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if needAccessToken {
            try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}

// MARK: - Methods for Errors & Exceptions
extension API {
    func handleAPIError(response: HTTPURLResponse, data: Data) async throws {
        switch response.statusCode {
        case 300...399:
            throw NetworkError.BadRequest
            
        case 400...499:
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
            
        case 500...599:
            throw NetworkError.ServerError
        default: break
        }
    }
    
    func parseCustomException(response: String) -> CustomException {
        let components = response.components(separatedBy: ",")
        
        let errorCode = Int(components[0].replacingOccurrences(of: "\"CustomException(errorCode=", with: "").replacingOccurrences(of: "CustomException(errorCode=", with: "")) ?? 0
        
        let errorMessage = components[1].replacingOccurrences(of: " errorMessage=", with: "").replacingOccurrences(of: ")\"", with: "").replacingOccurrences(of: ")", with: "")
        
        print(errorCode, errorMessage)
        
        return CustomException(errorCode: errorCode, errorMessage: errorMessage)
    }
}

// MARK: - Methods For Authenticate & Authorize
extension API {
    func getAccessToken() async throws -> String {
        guard let accessToken = KeychainManager.readToken(key: "accessToken") else {
            try await API.sharedAPI.reissue()
            throw NetworkError.Reissue
        }
        
        return accessToken
    }
    
    func getIntraId() -> String {
        guard let intraId = KeychainManager.readToken(key: "intraId") else {
            print("getIntraId method returned 0")
            return "0"
        }
        return intraId
    }
    
    func reissue() async throws {
        var request = try await getURLRequest(subURL: "/jwt/reissue", needContentType: true, needAccessToken: false, httpMethod: .post)
        
        guard let requestBody = try?JSONEncoder().encode(ReissueRequestDTO(intraId: getIntraId())) else {
            print("Failed Create Reissue Request body")
            throw NetworkError.invalidRequestBody
        }
        
        request.httpBody = requestBody
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        print("----- reissue -----")
        
        switch response.statusCode {
        case 200 ... 299:
            if response.mimeType == "text/html" {
                DispatchQueue.main.async {
                    MainViewModel.shared.isLogin = false
                }
                throw NetworkError.Reissue
            } else {
                let reissueAccessToken = try JSONDecoder().decode(ReissueDTO.self, from: data).accessToken
                KeychainManager.updateToken(key: "accessToken", token: "Bearer " + reissueAccessToken)
                return
            }
        case 400 ... 499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    DispatchQueue.main.async {
                        MainViewModel.shared.isLogin = false
                    }
                    throw NetworkError.Reissue
                }
            } else {
                throw NetworkError.BadRequest
            }
        case 300...599:
            try await handleAPIError(response: response, data: data)
            
        default: print("Unknown HTTP Response Status Code")
        }
    }
}
