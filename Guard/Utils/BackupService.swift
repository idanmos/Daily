//
//  BackupService.swift
//  Daily
//
//  Created by Idan Moshe on 04/12/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class BackupService: NSObject {
    
    static let shared = BackupService()
    
    private let fileExtension: String = "dailyApp"
    
    private lazy var documentDirectory: String? = {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }()
        
    func save(value: [Any], fileName: String) -> String? {
        guard let path: String = self.documentDirectory else { return nil }
        let filePath: String = path.appending("/\(fileName).\(self.fileExtension)")
        let success: Bool = (value as NSArray).write(toFile: filePath, atomically: true)
        return success ? filePath : nil
    }
    
    func load(fileName: String) -> [[String: Any]] {
        guard let path: String = self.documentDirectory else { return [] }
        let filePath: String = path.appending("/\(fileName).\(self.fileExtension)")
        return self.load(url: URL(fileURLWithPath: filePath))
    }
    
    @objc func load(url: URL) -> [[String: Any]] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        guard let importedItems = NSArray(contentsOf: url) else { return [] }
        guard let results = importedItems as? [[String: Any]] else { return [] }
        return results
    }
    
}
