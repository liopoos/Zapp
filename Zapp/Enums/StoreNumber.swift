//
//  StoreNumber.swift
//  Zapp
//
//  Created by hades on 2023/4/6.
//

import Foundation

/**
 Number of history stores.
 */
enum StoreNumber: Int, Codable, CaseIterable {
    case number_10 = 10
    case number_20 = 20
    case number_50 = 50
    case number_100 = 200
    
    var label: String {
        switch self {
        case .number_10:
            return "10"
        case .number_20:
            return "20"
        case .number_50:
            return "50"
        case .number_100:
            return "100"
        }
    }
    
    mutating func setValue(label: String) {
        switch label {
        case "10":
            self = .number_10
        case "20":
            self = .number_20
        case "50":
            self = .number_50
        case "100":
            self = .number_100
        default:
            self = .number_10
        }
    }
}
