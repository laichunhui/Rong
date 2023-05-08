//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/4.
//

import Foundation

private let standardDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

private let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd"
    return formatter
}()


public extension String {
    func transToYMFormatter() -> String {
        if let date = standardDateFormatter.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            return formatter.string(from: date)
        }
        return self
    }
    
    func transToMDFormatter() -> String {
        if let date = standardDateFormatter.date(from: self) {
            return dayFormatter.string(from: date)
        }
        return self
    }
    
    func transToDate() -> Date? {
        if let date = standardDateFormatter.date(from: self) {
            return date
        }
        return nil
    }
}

public extension Date {
    var standardDateFormatString: String {
        return standardDateFormatter.string(from: self)
    }
}
