//
//  Collection+Safe.swift
//
//
//  Created by ErrorErrorError on 1/9/23.
//
//

import Foundation

public extension Collection where Self: RangeReplaceableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        } set {
            if indices.contains(index), let newValue {
                remove(at: index)
                insert(newValue, at: index)
            } else {
                remove(at: index)
            }
        }
    }
}
