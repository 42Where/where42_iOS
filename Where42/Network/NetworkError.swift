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
