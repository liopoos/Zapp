//
//  AppDelegate.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import Foundation
import AppKit
import Cocoa
import SwiftUI
import CoreImage
import LaunchAtLogin

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, NSMenuDelegate, NSServicesMenuRequestor {
    private(set) static var shared: AppDelegate!
    private var appState = AppStateContainer()
    private var appConfig = DefaultsManager.shared.getConfig()
    
    private var mainMenu: NSMenu!
    private var statusItem: NSStatusItem!
    
    private let menuController = MenuController()
    
    // Continuity Camera window to use Continuity Camera.
    var continuityWindow: NSWindow!

    @objc func captureScreen() {
        appState.importQRCodeFromScreen()
    }
    
    @objc func fromClipboard() {
        appState.importQRCodeFromClipboard()
    }
    
    @objc func fromContinuityCamera() {
        // Draw Continuity Camera windows.
        continuityWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 200, height: 200), styleMask: [.titled, .closable, .borderless], backing: .buffered, defer: false)
        
        let continuityView = ContinuityViewController()
        continuityView.appState = appState
        continuityWindow.contentViewController = continuityView
        continuityWindow.isReleasedWhenClosed = false
        continuityWindow.center()
        continuityWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func pasteToClipboard(_ sender: NSMenuItem) {
        if let message = sender.representedObject as? String {
            print("Message data: \(message)")
            appState.pasteToClipboard(message: message)
        }
    }
    
    /**
     Handle clear histories.
     */
    @objc func clearHistory() {
        appState.clearHistory()
    }

    /**
     Handle copy result to clipboard.
     */
    @objc func copyToClipboard(_ menuItem: NSMenuItem) {
        appConfig.copy_to_clipboard = menuItem.state == .on ? false : true
        DefaultsManager.shared.setConfig(appConfig: appConfig)
        menuItem.state = appConfig.copy_to_clipboard ? .on : .off
    }
    
    @objc func setStoreNumber(_ menuItem: NSMenuItem) {
        appConfig.store_number.setValue(label: menuItem.title)
        DefaultsManager.shared.setConfig(appConfig: appConfig)
    }
    
    /**
     Handle launch at login.
     */
    @objc func launchAtLogin(_ menuItem: NSMenuItem) {
        appConfig.launch_at_login = !appConfig.launch_at_login
        LaunchAtLogin.isEnabled = appConfig.launch_at_login
        DefaultsManager.shared.setConfig(appConfig: appConfig)
        menuItem.state = appConfig.launch_at_login ? .on : .off
    }
    
    /**
     Handle play sound effect.
     */
    @objc func playSoundEffect(_ menuItem: NSMenuItem) {
        appConfig.play_sound_effect = !appConfig.play_sound_effect
        DefaultsManager.shared.setConfig(appConfig: appConfig)
        menuItem.state = appConfig.play_sound_effect ? .on : .off
    }
    
    /**
     Update history menu list.
     */
    func updateZappList() {
        let zappTag = 99
        let zappMainMenuList = appState.getZapps().prefix(9)
        let zappSubMenuList = appState.getZapps().dropFirst(9)
        
        // Remove all associated Tag items first.
        for item in mainMenu.items where item.tag == zappTag {
            mainMenu.removeItem(item)
        }
        
        // Empty view.
        if appState.getZapps().count <= 0 {
            let emptyMenuItem = NSMenuItem(title: "No History".localized, action: nil, keyEquivalent: "")
            emptyMenuItem.tag = zappTag
            mainMenu.insertItem(emptyMenuItem, at: 2)
            return
        }
        
        // Add main menu list.
        for (index, zapp) in zappMainMenuList.enumerated() {
            let zappMenuItem = NSMenuItem(title: "", action: #selector(pasteToClipboard(_:)), keyEquivalent: String(index + 1))
            zappMenuItem.title = zapp.message.abbreviated(to: 25)
            zappMenuItem.tag = zappTag
            zappMenuItem.representedObject = zapp.message
            zappMenuItem.image = NSImage(systemSymbolName: zapp.type.sf, accessibilityDescription: zapp.type.sf)
            mainMenu.insertItem(zappMenuItem, at: index + 2)
        }
        
        // Add "More Zapps" menu sub list.
        if zappSubMenuList.count > 0 {
            let zappMoreMenuItem = NSMenuItem(title: "More Zapps...".localized, action: nil, keyEquivalent: "")
            zappMoreMenuItem.tag = zappTag
            let zappSubMenu = NSMenu()
            zappMoreMenuItem.submenu = zappSubMenu
            zappSubMenu.delegate = self
            for zapp in zappSubMenuList {
                let zappSubMenuItem = NSMenuItem(title: "", action: #selector(pasteToClipboard(_:)), keyEquivalent: "")
                zappSubMenuItem.title = zapp.message.abbreviated(to: 25)
                zappSubMenuItem.representedObject = zapp.message
                zappSubMenuItem.image = NSImage(systemSymbolName: zapp.type.sf, accessibilityDescription: zapp.type.sf)
                zappSubMenu.addItem(zappSubMenuItem)
            }
            mainMenu.insertItem(zappMoreMenuItem, at: 11)
        }
    }
    
    /**
     Update menu list state.
     */
    func updateMenuList(menu: NSMenu) {
        // Update store sub menu.
        if let storeItem = menu.item(withTag: 20) {
            let storeNumber = appConfig.store_number
            for subItem in storeItem.submenu!.items {
                subItem.state = subItem.title == storeNumber.label ? .on : .off
            }
        }
    }
    
    /**
     Update the list when the menu open.
     */
    func menuWillOpen(_ menu: NSMenu) {
        updateZappList()
        updateMenuList(menu: menu)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        AppDelegate.shared = self
        
        NSApp.setActivationPolicy(.accessory)
        // Hide Main view.
        if let window = NSApplication.shared.windows.first {
            window.close()
        }

        // Load local data.
        appState.loadZappsFromFile()
    
        // Create menu service.
        mainMenu = menuController.getMenu()
        mainMenu.delegate = self
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = mainMenu
        
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(systemSymbolName: "qrcode.viewfinder", accessibilityDescription: "qrcode")
            statusButton.image?.size = NSSize(width: 20, height: 20)
            statusButton.image?.isTemplate = true
            statusButton.target = self
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.accessory)
        return false
    }
    
}
