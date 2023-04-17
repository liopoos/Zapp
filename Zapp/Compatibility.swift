//
//  Compatibility.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import Foundation
import AppKit

extension String {
    func abbreviated(to maxLength: Int) -> String {
        guard maxLength > 0 else {
            return ""
        }
    
        var length = 0
        var result = ""
        for character in self {
            let characterLength = character.isASCII ? 1 : 2
            if length + characterLength <= maxLength {
                result.append(character)
                length += characterLength
            } else {
                break
            }
        }
        
        if result.count < self.count {
            result.append("...")
        }
    
        return result
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension NSMenuItem {
    var maxTitleLength: Int {
        get {
            return UserDefaults.standard.integer(forKey: "MaxTitleLength")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "MaxTitleLength")
        }
    }
    
    var abbreviatedTitle: String {
        let maxLength = maxTitleLength
        guard maxLength > 0 else {
            return self.title
        }
        if self.title.count <= maxLength {
            return self.title
        }
        let abbreviation = "..."
        let headLength = (maxLength - abbreviation.count) / 2
        let tailLength = maxLength - abbreviation.count - headLength
        let headIndex = self.title.index(self.title.startIndex, offsetBy: headLength)
        let tailIndex = self.title.index(self.title.endIndex, offsetBy: -tailLength)
        let abbreviatedTitle = "\(self.title[..<headIndex])\(abbreviation)\(self.title[tailIndex...])"
        return abbreviatedTitle
    }
    
    func setTitleAndAbbreviate(_ newTitle: String) {
        self.title = newTitle.abbreviated(to: maxTitleLength)
    }
}

public extension NSSound {
    static let basso     = NSSound(named: .basso)
    static let blow      = NSSound(named: .blow)
    static let bottle    = NSSound(named: .bottle)
    static let frog      = NSSound(named: .frog)
    static let funk      = NSSound(named: .funk)
    static let glass     = NSSound(named: .glass)
    static let hero      = NSSound(named: .hero)
    static let morse     = NSSound(named: .morse)
    static let ping      = NSSound(named: .ping)
    static let pop       = NSSound(named: .pop)
    static let purr      = NSSound(named: .purr)
    static let sosumi    = NSSound(named: .sosumi)
    static let submarine = NSSound(named: .submarine)
    static let tink      = NSSound(named: .tink)
}



public extension NSSound.Name {
    static let basso     = NSSound.Name("Basso")
    static let blow      = NSSound.Name("Blow")
    static let bottle    = NSSound.Name("Bottle")
    static let frog      = NSSound.Name("Frog")
    static let funk      = NSSound.Name("Funk")
    static let glass     = NSSound.Name("Glass")
    static let hero      = NSSound.Name("Hero")
    static let morse     = NSSound.Name("Morse")
    static let ping      = NSSound.Name("Ping")
    static let pop       = NSSound.Name("Pop")
    static let purr      = NSSound.Name("Purr")
    static let sosumi    = NSSound.Name("Sosumi")
    static let submarine = NSSound.Name("Submarine")
    static let tink      = NSSound.Name("Tink")
}


extension NSImage {
    func resize(_ to: CGSize, isPixels: Bool = false) -> NSImage {
        
        var toSize = to
        let screenScale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1.0

        if isPixels {
            
            toSize.width = to.width / screenScale
            toSize.height = to.height / screenScale
        }
    
        let toRect = NSRect(x: 0, y: 0, width: toSize.width, height: toSize.height)
        let fromRect =  NSRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let newImage = NSImage(size: toRect.size)
        newImage.lockFocus()
        draw(in: toRect, from: fromRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        newImage.unlockFocus()
    
        return newImage
    }
}
