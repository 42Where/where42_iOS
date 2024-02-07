//
//  WhereAppDelegate.swift
//  Where42
//
//  Created by 현동호 on 2/7/24.
//

import SwiftUI

final class WhereAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)

        sceneConfig.delegateClass = WhereSceneDelegate.self

        return sceneConfig
    }
}
