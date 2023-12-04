//
//  API.swift
//  Where42
//
//  Created by 현동호 on 11/6/23.
//

import Foundation

class API: ObservableObject {
    enum NetworkError: Error {
        case invalidHTTPResponse
    }
}

// extension Bundle {
//    var apiKey: String? {
//        if let filePath = url(forResource: "Environment", withExtension: "plist") {
//            do {
//                let infoPlistData = try Data(contentsOf: filePath)
//
//                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, format: nil) as? [String: Any] {
//                    return dict["API_PATH"]
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
// }

// class BaseEnv {
//    var Env: [String: Any]?
//
//    init(resourceName: String) {
//        if let filePath = Bundle.main.url(forResource: resourceName, withExtension: "plist") {
//            do {
//
//
//                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, format: nil) as? [String: Any] {
//                    Env = dict
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
// }
