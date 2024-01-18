//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import SwiftUI

class API: ObservableObject {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
    @AppStorage("token") var token = ""
    @AppStorage("isLogin") var isLogin = false

    enum NetworkError: Error {
        case invalidURL
        case invalidRequestBody
        case invalidHTTPResponse
        case BadRequest
        case ServerError
        case Token
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
        default:
            print(message + ": " + error.localizedDescription)
        }
    }

    func parseCustomException(response: String) -> CustomException {
        let components = response.components(separatedBy: ",")

        let errorCode = Int(components[0].replacingOccurrences(of: "\"CustomException(errorCode=", with: "")) ?? 0
        let errorMessage = components[1].replacingOccurrences(of: " errorMessage=", with: "").replacingOccurrences(of: ")\"", with: "")

        return CustomException(errorCode: errorCode, errorMessage: errorMessage)
    }
}
