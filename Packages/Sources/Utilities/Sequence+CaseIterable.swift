//
//  Sequence+CaseIterable.swift
//
//
//  Created by ErrorErrorError on 12/27/22.
//
//

import Foundation

public extension Collection where Element: CaseIterable {
    static var allCases: Element.AllCases { Element.allCases }
}
