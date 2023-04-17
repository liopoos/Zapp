//
//  QRCodeImportType.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import Foundation

enum QRCodeImportType: String, Codable {
    case clipboard
    case capture
    case continuity_camera
    
    var sf: String {
        switch self {
        case .clipboard:
            return "doc.on.clipboard"
        case .capture:
            return "photo"
        case .continuity_camera:
            return "camera.viewfinder"
        }
    }
}
