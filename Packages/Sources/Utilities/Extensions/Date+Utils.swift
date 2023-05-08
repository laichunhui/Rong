//
//  Date+Utils.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 9/27/22.
//

import Foundation

public extension Date {
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}
