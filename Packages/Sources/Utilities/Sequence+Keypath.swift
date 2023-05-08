//
//  Sequence+Keypath.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/30/22.
//

import Foundation

public extension Sequence {
    func sorted(by keyPath: KeyPath<Element, some Comparable>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func min(by keyPath: KeyPath<Element, some Comparable>) -> Element? {
        self.min { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func max(by keyPath: KeyPath<Element, some Comparable>) -> Element? {
        self.max { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}
