//
//  MyViewController.swift
//  Zapp
//
//  Created by hades on 2023/4/4.
//

import Foundation
import AppKit

class ContinuityViewController: NSViewController {
    var appState: AppStateContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        view.wantsLayer = true
        
        let stackView = NSStackView()
        stackView.orientation = .vertical

        let symbol = NSImage(systemSymbolName: "camera.viewfinder", accessibilityDescription: nil)!
        symbol.size = NSSize(width: 60, height: 60)
        let symbolView = NSImageView(image: symbol)
        symbolView.imageScaling = .scaleProportionallyUpOrDown
        symbolView.frame = NSRect(x: 0, y: 0, width: symbol.size.width, height: symbol.size.height)

        stackView.addArrangedSubview(symbolView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = NSButton(title: "Import".localized, target: nil, action: #selector(showMenu(_:)))
        let buttonMenu = NSMenu()
        button.menu = buttonMenu
        button.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            symbolView.widthAnchor.constraint(equalToConstant: symbol.size.width),
            symbolView.heightAnchor.constraint(equalToConstant: symbol.size.height)
        ])
        
        self.view = view
    }
    
    override func validRequestor(forSendType sendType: NSPasteboard.PasteboardType?, returnType: NSPasteboard.PasteboardType?) -> Any? {
        if let pasteboardType = returnType,
           // The service is image-related.
           NSImage.imageTypes.contains(pasteboardType.rawValue) {
            return self
        } else {
            // Let objects in the responder chain handle the message.
            return super.validRequestor(forSendType: sendType, returnType: returnType)
        }
    }
    
    @objc func readSelectionFromPasteboard(_ pasteboard: NSPasteboard) -> Bool
    {
        guard pasteboard.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else { return false }
        guard let image = NSImage(pasteboard: pasteboard) else { return false }
        
        appState.importQRCodeFromContinuityCamera(image: image)
        closeWindow()
        
        return true
    }
    
    @objc func closeWindow() {
        view.window?.close()
    }
    
    @objc func showMenu(_ sender: NSButton) {
        guard let menu = sender.menu else { return }
        guard let event = NSApplication.shared.currentEvent else { return }
        
        // AppKit uses the Responder Chain to figure out where to insert the Continuity Camera menu items.
        // So making ourselves `firstResponder` here is important.
        self.view.window?.makeFirstResponder(self)
        NSMenu.popUpContextMenu(menu, with: event, for: sender)
    }
}
