//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

class API {
    // MARK: - Properties
    static var sharedAPI = API()
    
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    @AppStorage("intraId") var intraId: Int = 0

    // MARK: - Methods
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
    
    func getURLRequest(subURL: String) throws -> URLRequest {
        guard let requestURL = URL(string: baseURL + subURL) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: requestURL)
        return request
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
    
    //    func getRefreshToken() -> String {
    //        guard let refreshToken = KeychainManager.readToken(key: "refreshToken") else {
    //            return ""
    //        }
    //
    //        return refreshToken
    //    }
    
    func getIntraId() -> String {
        guard let intraId = KeychainManager.readToken(key: "intraId") else {
            print("getIntraId method returned 0")
            return "0"
        }
        return intraId
    }
    
    func reissue() async throws {
        guard let requestURL = URL(string: baseURL + "/jwt/reissue") else {
            throw NetworkError.invalidURL
        }
        
        do {
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let requestBody = try?JSONEncoder().encode(ReissueRequestDTO(intraId: getIntraId())) else {
                print("Failed Create Reissue Request body")
                throw NetworkError.invalidRequestBody
            }
            
            request.httpBody = requestBody
            //            request.addValue(getRefreshToken(), forHTTPHeaderField: "Authorization")
            
            //        print("API.sharedAPI.refreshToken: ", API.sharedAPI.refreshToken)
            //            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }
            
            //            print(String(data: data, encoding: String.Encoding.utf8)!)
            
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
                    //                    API.sharedAPI.accessToken = "Bearer " + reissueAccessToken
                    KeychainManager.updateToken(key: "accessToken", token: "Bearer " + reissueAccessToken)
                    return
                }
            case 300...599:
                try await handleAPIError(response: response, data: data)
            default: print("Unknown HTTP Response Status Code")
            }
        } catch NetworkError.Reissue, NetworkError.TokenError {
            throw NetworkError.Reissue
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to get member infomation")
        }
    }
}
