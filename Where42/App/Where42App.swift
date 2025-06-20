//
//  Where42App.swift
//  Where42
//
//  Created by 현동호 on 10/27/23.
//

import SwiftUI

@main
struct Where42App: App {
    @UIApplicationDelegateAdaptor(WhereAppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            Where42()
        }
    }
}
