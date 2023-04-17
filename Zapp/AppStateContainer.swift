//
//  AppStateContainer.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import Foundation
import AppKit
import Cocoa

class AppStateContainer {
    private var zapps: Array<Zapp> = [] // history list
    
    public func getZapps() -> [Zapp] {
        return zapps
    }
    
    public func importQRCodeFromScreen() {
        if let image = QRCodeImporter.shared.capture() {
            decodeCodeFromImage(image: image, type: .capture)
        }
    }

    public func importQRCodeFromClipboard() {
        if let image = QRCodeImporter.shared.clipboard() {
            decodeCodeFromImage(image: image, type: .clipboard)
        }
    }
    
    public func importQRCodeFromContinuityCamera(image: NSImage) {
        if let image = QRCodeImporter.shared.continuityCamera(image: image) {
            decodeCodeFromImage(image: image, type: .continuity_camera)
        }
    }
    
    /**
     Try Decode image.
     */
    public func decodeCodeFromImage(image: URL, type: QRCodeImportType) {
        let decoder = QRCodeDecoder()
        let decodeStatus = decoder.decode(image: NSImage(contentsOfFile: image.path)!)
        let isPlaySound = DefaultsManager.shared.getConfig().play_sound_effect
        // Remove tmp file.
        QRCodeImporter.shared.remove(url: image)
        if decodeStatus == .success {
            // Append zapps.
            appendZapp(zapp: Zapp(path: image, type: type, message: decoder.getMessage()!, created_at: Date()))
            
            pasteToClipboard(message: decoder.getMessage()!)
            
            // Play sound effect.
            if isPlaySound { SoundManager.shared.success() }
            
            if HistoryManager.shared.save(data: zapps) {
                print("Decode QRCdoe success.")
            }
        } else {
            if isPlaySound { SoundManager.shared.error() }
            print("Decode QRCdoe error.")
        }
    }
    
    /**
     Load history from local file.
     */
    public func loadZappsFromFile() {
        // Read history list from locl file
        if let zappsFromFile = HistoryManager.shared.load() {
            zapps = zappsFromFile
        }
    }
    
    /**
     Paste the message to clipboard.
     */
    public func pasteToClipboard(message: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(message, forType: .string)
    }
    
    /**
     Clear histories from file.
     */
    public func clearHistory() {
        if HistoryManager.shared.remove() {
            zapps.removeAll()
        }
    }
    
    /**
     Append zapp to list.
     */
    private func appendZapp(zapp: Zapp) {
        let maxStoreNumber = DefaultsManager().getConfig().store_number.rawValue
        zapps.insert(zapp, at: 0)
        
        if maxStoreNumber > 0 && zapps.count > maxStoreNumber {
            zapps.remove(at: maxStoreNumber)
        }
    }
}
