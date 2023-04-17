//
//  DefaultsManager.swift
//  Zapp
//
//  Created by hades on 2023/4/6.
//

import Foundation
import DefaultsKit
import LaunchAtLogin


struct AppConfig: Codable {
    var copy_to_clipboard: Bool = true // Whether to copy the results to the clipboard.
    var store_number: StoreNumber = .number_10 // Maximum number of historical records to be stored.
    var launch_at_login: Bool = LaunchAtLogin.isEnabled // Launch At Login state.
    var play_sound_effect = true // Play sound effect when decode QRCode.
}

class DefaultsManager {
    static let shared = DefaultsManager()
    
    let defaults = Defaults.shared
    let appKey = Key<AppConfig>("appConfigKey")
    
    public func setConfig(appConfig: AppConfig) {
        defaults.set(appConfig, for: appKey)
    }
    
    public func getConfig() -> AppConfig {
        guard let appConfig = defaults.get(for: appKey) else {
            return AppConfig()
        }
        
        return appConfig
    }
}
