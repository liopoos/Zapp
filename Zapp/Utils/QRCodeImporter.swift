//
//  ScreenCaptureController.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import Foundation
import AppKit

class QRCodeImporter {
    static let shared = QRCodeImporter()
    
    private let tmpDir: String = NSTemporaryDirectory()
    
    /**
     Generate a temporary file path.
     */
    private func genDestination() -> URL {
        let destination = URL(fileURLWithPath: tmpDir.appending(NSUUID().uuidString + ".png"))
        return destination
    }
    
    /**
     Writes the image data to a local file.
     */
    private func writeImageToFile(image: NSImage) -> URL? {
        let destination = genDestination()
        
        guard let imageData = image.tiffRepresentation else {
            return nil
        }
        
        guard let bitmapImageRep = NSBitmapImageRep(data: imageData) else {
            return nil
        }
           
        guard let pngData = bitmapImageRep.representation(using: .png, properties: [:]) else {
            return nil
        }
           
        do {
            try pngData.write(to: URL(fileURLWithPath: destination.path), options: .atomicWrite)
        } catch {
            return nil
        }
        
        return destination
    }
    
    /**
     Use system screencapture cli to capture image.
     */
    public func capture() -> URL? {
        let destination = genDestination()
    
        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", "-x", destination.path]
        task.launch()
        task.waitUntilExit()
        
        // Make sure the file exist.
        if FileManager.default.fileExists(atPath: destination.path) {
            return destination
        }
        
        return nil
    }
    
    /**
    Import image from clipboard.
     */
    public func clipboard() -> URL? {
        let pasteboard = NSPasteboard.general
        
        guard pasteboard.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else {
            return nil
        }
        
        guard let image = NSImage(pasteboard: pasteboard) else {
            return nil
        }
        
        if let destination = writeImageToFile(image: image) {
            return destination
        }
        
        return nil
    }

    public func continuityCamera(image: NSImage) -> URL? {
        if let destination = writeImageToFile(image: image) {
            return destination
        }
        
        return nil
    }
    
    /**
     Remove the temporary file.
     */
    public func remove(url: URL) {
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch {}
    }
}
