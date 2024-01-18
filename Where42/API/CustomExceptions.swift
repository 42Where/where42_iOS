//
//  CustomExceptions.swift
//  Where42
//
//  Created by 현동호 on 1/16/24.
//

import Foundation

/*

 Custom error code
 NO_MEMBER(1000, "존재하지 않는 맴버입니다."),
 DUPLICATED_MEMBER(1001, "이미 존재하는 맴버입니다.");

 NO_GROUP(1101, "그룹이 존재하지 않습니다."),
 DUPLICATED_GROUP_NAME(1101, "이미 존재하는 그룹 이름입니다.");

 DESERIALIZE_FAIL(1200, "json 맵핑에 실패 했습니다.");

 INVALID_CONTEXT(1300, "유효하지 않은 검색 입력 값입니다."),
 INVALID_LENGTH(1301, "2자 이상 입력해주시길 바랍니다.");

 INVALID_OAUTH_TOKEN(1400,”유효한 OAuth 토큰이 없습니다."),
 INVALID_OAUTH_TOKEN_NAME(1401, "유요하지 않은 OAuth 토큰 이름입니다."),
 DUPLICATED_OAUTH_TOKEN_NAME(1402, "이미 등록된 OAuth 토큰입니다.");

 INVALIDED_TOKEN(1500,”유효한 토큰이 없습니다."),
 WRONG_SIGNED_TOKEN(1501, "서명이 잘못된 토큰입니다."),
 EXPIRED_TOKEN_TIME_OUT(1502, "만료된 토큰입니다."),
 UNSUPPORTED_TOKEN(1503, "지원 되지 않는 토큰입니다."),
 ILLEGAL_TOKEN(1504, "잘못된 토큰입니다.");

 UNAUTHORIZED(1600, "Unauthorized 권한이 없습니다."),
 TOO_MANY_REQUEST(1601, "42API 요청 횟수를 초과하였습니다."),
 HANE_SERVICE(1602, "HANE-API 요청 실패"),
 WHITE_LABEL_PAGE(1603, "잘못된 접근입니다"),
 BAD_REQUEST(1604, "잘못된 요청입니다");

 */

struct CustomException: Codable {
    var errorCode: Int
    var errorMessage: String

    init(errorCode: Int, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }

    func handleError() -> Bool {
        print(self.errorMessage)
        switch self.errorCode {
        case 1000:
            return true
        case 1001:
            return true
        case 1102:
            return true
        case 1200:
            return true
        case 1300:
            return false
        case 1301:
            return false
        case 1400:
            return false
        case 1401:
            return false
        case 1402:
            return false
        case 1500:
            return false
        case 1501:
            return false
        case 1502:
            return false
        case 1503:
            return false
        case 1504:
            return false
        case 1600:
            return false
        case 1601:
            return false
        case 1602:
            return false
        case 1603:
            return false
        case 1604:
            return false
        default:
            return true
        }
    }
}
