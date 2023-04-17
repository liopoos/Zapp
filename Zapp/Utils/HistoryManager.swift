//
//  HistorySave.swift
//  Zapp
//
//  Created by hades on 2023/4/3.
//

import Foundation


class HistoryManager {
    static let shared = HistoryManager()
    private let fileManager = FileManager.default
    private var filePath: URL

    private init() {
        filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("history.json")
        print(filePath)
    }
    
    /**
     Save history.json to Document.
     */
    func save(data: [Zapp]) -> Bool {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        guard let jsonData = try? jsonEncoder.encode(data) else {
            print("Failed to encode person to JSON.")
            return false
        }
        
      
        do {
            try jsonData.write(to: filePath)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Try load file and convert data from history.json
     */
    func load() -> Array<Zapp>? {
        if !fileManager.fileExists(atPath: filePath.path) {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: filePath)
            let datas = try jsonDecoder.decode([Zapp].self, from: jsonData)
            
            return datas
        } catch {
            print("Failed to load data from file: \(error.localizedDescription)")
            return nil
        }
    }
    
    /**
     Remove history.json data.
     */
    func remove() -> Bool {
        do {
            try fileManager.removeItem(atPath: filePath.path)
            print("File deleted successfully.")
            return true
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
            return false
        }
    }

}
