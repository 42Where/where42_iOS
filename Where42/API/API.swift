//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import Foundation

class API: ObservableObject {
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""

    enum NetworkError: Error {
        case invalidHTTPResponse
        case BadRequest
        case ServerError
    }

    func errorPrint(_ error: Error, message: String) {
        switch error {
        case NetworkError.invalidHTTPResponse:
            fatalError("잘못된 HTTP Response 입니다")
        case NetworkError.BadRequest:
            fatalError("잘못된 요청입니다")
        case NetworkError.ServerError:
            fatalError("서버 에러입니다")
        default:
            fatalError(message + ": " + error.localizedDescription)
        }
    }
}
