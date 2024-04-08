//
//  KeychainManager.swift
//  Where42
//
//  Created by 현동호 on 4/8/24.
//

import Security
import SwiftUI

class KeychainManager {
    class func createToken(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8) as Any
        ]
        SecItemDelete(query)

        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }

    class func readToken(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any, // CFData 타입으로 반환
            kSecMatchLimit: kSecMatchLimitOne // 중복되는 경우, 하나의 값만 반환
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let token = String(data: retrievedData, encoding: .utf8)
            return token
        } else {
            print("Failed read token", status)
            return nil
        }
    }

    class func updateToken(key: String, token: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        let attributes: NSDictionary = [
            kSecValueData: token.data(using: .utf8) as Any
        ]

        let status = SecItemUpdate(query, attributes)

        assert(status == noErr, "failed to update the value, status code = \(status)")
    }

    class func deleteToken(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
