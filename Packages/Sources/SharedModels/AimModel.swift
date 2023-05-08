//
//  AimModel.swift
//  DieWelle
//
//  Created by laichunhui on 2023/3/28.
//

import Foundation
import Utilities

public struct AimModel: Codable, Identifiable, Equatable {
    public var id: String {
        return self.date.standardDateFormatString
    }

    public var date: Date
    public var value: Double
    
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
