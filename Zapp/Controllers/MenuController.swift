//
//  MenuController.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import Foundation
import AppKit
import SwiftUI

class MenuController: NSObject, NSMenuDelegate {
    private var menu: NSMenu!
    
    override init() {
        super.init()
        createMenu()
    }
    
    func getMenu() -> NSMenu {
        return menu
    }
    
    func createMenu() {
        menu = NSMenu()
        menu.delegate = self
        
        // App Version
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"]
            let appName = infoDictionary["CFBundleDisplayName"]
            let appBuild = infoDictionary["CFBundleVersion"]
            menu.addItem(withTitle: (appName as! String) + " v\(appVersion!)(\(appBuild!))", action:  nil, keyEquivalent: "")
            menu.addItem(NSMenuItem.separator())
        }
        
//        let menuItemList = NSHostingView(rootView: MenuView())
//        menuItemList.frame = NSRect(x: 0, y: 0, width: 240, height: 165)
//        let menuItem = NSMenuItem()
//        menuItem.view = menuItemList
//        menu.addItem(menuItem)
        
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Capture...".localized, action: #selector(AppDelegate.captureScreen), keyEquivalent: "x"))
        menu.addItem(NSMenuItem(title: "From Clipboard".localized, action: #selector(AppDelegate.fromClipboard), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "From iPhone OR iPad".localized, action: #selector(AppDelegate.fromContinuityCamera), keyEquivalent: "q"))
        
        menu.addItem(NSMenuItem.separator())
        
        let storeSubMenu = NSMenu()
        for type in StoreNumber.allCases {
            storeSubMenu.addItem(NSMenuItem(title: type.label, action: #selector(AppDelegate.setStoreNumber(_:)), keyEquivalent: ""))
        }
        let storeItem = menu.addItem(withTitle: "History Numbers".localized, action: nil, keyEquivalent: "")
        storeItem.tag = 20
        storeItem.submenu = storeSubMenu
        
        let copyItem = menu.addItem(withTitle: "Copy to Clipboard".localized, action: #selector(AppDelegate.copyToClipboard) , keyEquivalent: "")
        copyItem.state = DefaultsManager.shared.getConfig().copy_to_clipboard ? .on : .off
        menu.addItem(NSMenuItem(title: "Clear History".localized, action: #selector(AppDelegate.clearHistory), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        let launchItem = menu.addItem(withTitle: "Launch at login".localized, action: #selector(AppDelegate.launchAtLogin) , keyEquivalent: "")
        launchItem.state = DefaultsManager.shared.getConfig().launch_at_login ? .on : .off
        let playSoundItem = menu.addItem(withTitle: "Play sound".localized, action: #selector(AppDelegate.playSoundEffect) , keyEquivalent: "")
        playSoundItem.state = DefaultsManager.shared.getConfig().play_sound_effect ? .on : .off
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit".localized, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
}
