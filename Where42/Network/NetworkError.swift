//
//  NetworkError.swift
//  Where42
//
//  Created by ch on 3/6/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidHTTPResponse
    case BadRequest
    case ServerError
    case TokenError
    case Reissue
    case VersionUpdate
}

struct ErrorHandler {
    static func errorPrint(_ error: Error, message: String) {
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
        case NetworkError.TokenError:
            print("유효하지 않은 토큰입니다")
        case NetworkError.Reissue:
            print("잠시 후 다시 시도해 주세요")
        default:
            print(message + ": " + error.localizedDescription)
        }
    }    
}
