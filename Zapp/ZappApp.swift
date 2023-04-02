//
//  ZappApp.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import SwiftUI

@main
struct ZappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
