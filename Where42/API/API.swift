//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

struct reissueDTO: Codable {
    var accessToken: String
}

class API: ObservableObject {
    static var sharedAPI = API()

    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    @AppStorage("intraId") var intraId: Int = 0
    @AppStorage("accessToken") var accessToken = ""
    @AppStorage("refreshToken") var refreshToken = ""

    enum NetworkError: Error {
        case invalidURL
        case invalidRequestBody
        case invalidHTTPResponse
        case BadRequest
        case ServerError
        case Token
        case Reissue
    }

    func errorPrint(_ error: Error, message: String) {
        switch error {
        case NetworkError.invalidURL:
            print("URL 생성에 실패했습니다")
        case NetworkError.invalidRequestBody:
            print("Request Body 생성에 실패했습니다")
        case NetworkError.invalidHTTPResponse:
            print("잘못된 HTTP Response 입니다")
        case NetworkError.BadRequest:
            print("잘못된 요청입니다")
        case NetworkError.ServerError:
            print("서버 에러입니다")
        case NetworkError.Token:
            print("유효하지 않은 토큰입니다")
        case NetworkError.Reissue:
            print("잠시 후 다시 시도해 주세요")
        default:
            print(message + ": " + error.localizedDescription)
        }
    }

    func parseCustomException(response: String) -> CustomException {
        let components = response.components(separatedBy: ",")

        let errorCode = Int(components[0].replacingOccurrences(of: "\"CustomException(errorCode=", with: "").replacingOccurrences(of: "CustomException(errorCode=", with: "")) ?? 0

        let errorMessage = components[1].replacingOccurrences(of: " errorMessage=", with: "").replacingOccurrences(of: ")\"", with: "").replacingOccurrences(of: ")", with: "")

        print(errorCode, errorMessage)

        return CustomException(errorCode: errorCode, errorMessage: errorMessage)
    }

    func reissue() async throws {
        guard let requestURL = URL(string: baseURL + "/jwt/reissue") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue(API.sharedAPI.refreshToken, forHTTPHeaderField: "Authorization")

//        print("API.sharedAPI.refreshToken: ", API.sharedAPI.refreshToken)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidHTTPResponse
            }

            //            print(String(data: data, encoding: String.Encoding.utf8)!)

            print("----- reissue -----")
            accessToken = ""

            switch response.statusCode {
            case 200 ... 299:
                if response.mimeType == "text/html" {
                    DispatchQueue.main.async {
                        MainViewModel.shared.isLogin = false
                    }
                    throw NetworkError.Reissue
                } else {
                    let reissueAccessToken = try JSONDecoder().decode(reissueDTO.self, from: data).accessToken
                    API.sharedAPI.accessToken = "Bearer " + reissueAccessToken
                    return
                }

            case 300 ... 399:
                throw NetworkError.BadRequest

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

            case 500 ... 599:
                throw NetworkError.ServerError

            default: print("Unknown HTTP Response Status Code")
            }
        } catch NetworkError.Reissue {
            throw NetworkError.Reissue
        } catch {
            errorPrint(error, message: "Failed to get member infomation")
        }
    }
}
