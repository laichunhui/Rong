//  Log.swift
//  Anime Now! (macOS)
//
//  Created by ErrorErrorError on 12/20/22.
//
//

import Foundation
import OSLog

// MARK: - Logger

public enum Logger {
    public static func log(
        _ level: OSLogType = .debug,
        _ message: some CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line
    ) {
        os_log(
            "%{public}@",
            log: .base,
            type: level,
            "\((fileName as NSString).lastPathComponent) - \(functionName) at line \(lineNumber): \(message)"
        )
    }
}

private extension OSLog {
    static let base = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.errorerrorerror.anime-now", category: "app")
}
