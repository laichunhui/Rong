//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import Foundation
import Utilities

// MARK: - UserSettings

public struct UserSettings: Codable, Equatable {
    public var preferredProvider: String?

    public init(
        preferredProvider: String? = nil
    ) {
        self.preferredProvider = preferredProvider
    }
}
