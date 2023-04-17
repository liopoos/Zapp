//
//  ZappApp.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import SwiftUI

@main
struct ZappApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}
