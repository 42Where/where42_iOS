//
//  Where42App.swift
//  Where42
//
//  Created by 현동호 on 10/27/23.
//

import SwiftUI

@main
struct Where42App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Where42()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
