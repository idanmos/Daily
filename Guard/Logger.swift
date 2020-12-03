//
//  Logger.swift
//  Guard
//
//  Created by Idan Moshe on 04/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class Logger {
        
    static var shared = Logger()
    
    private init() {} // we are sure, nobody else could create it
    
    private func log(_ string: String, logLevel: Level? = nil, file: String, function: String, line: UInt) {
        var logMessage = ""
        if let _ = logLevel {
            logMessage = "\(Date()) \(logLevel!.rawValue): \(string)"
        } else {
            logMessage = "\(Date()), \(string)"
        }
        
        debugPrint(logMessage)
        
        let fm = FileManager.default
        let log = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write("\(logMessage)\n".data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? "\(logMessage)\n".data(using: .utf8)?.write(to: log)
        }
    }
    
    func trace(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .trace, file: file, function: function, line: line)
    }
    
    func debug(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .debug, file: file, function: function, line: line)
    }
    
    func info(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .info, file: file, function: function, line: line)
    }
    
    func notice(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .notice, file: file, function: function, line: line)
    }
    
    func warning(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .warning, file: file, function: function, line: line)
    }
    
    func error(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .error, file: file, function: function, line: line)
    }
    
    func critical(_ string: String, file: String = #file, function: String = #function, line: UInt = #line) {
        self.log(string, logLevel: .critical, file: file, function: function, line: line)
    }
    
}

extension Logger {
    
    enum Level: String, Codable, CaseIterable {
        case trace
        case debug
        case info
        case notice
        case warning
        case error
        case critical
    }
    
}

extension Logger.Level {
    
    internal var naturalIntegralValue: Int {
        switch self {
        case .trace:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .notice:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        case .critical:
            return 6
        }
    }
    
}

extension Logger.Level: Comparable {
    public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
        return lhs.naturalIntegralValue < rhs.naturalIntegralValue
    }
}

extension Logger {
    
    struct Message: ExpressibleByStringLiteral, Equatable, CustomStringConvertible, ExpressibleByStringInterpolation {
        public typealias StringLiteralType = String

        private var value: String

        public init(stringLiteral value: String) {
            self.value = value
        }

        public var description: String {
            return self.value
        }
    }
    
}
