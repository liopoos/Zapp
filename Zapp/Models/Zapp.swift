//
//  Zapp.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import Foundation

struct Zapp: Codable {
    var path: URL
    var type: QRCodeImportType
    var message: String
    var created_at: Date
}
