//
//  Selectable.swift
//
//
//  Created by ErrorErrorError on 1/4/23.
//
//

import Foundation

// MARK: - Selectable

public struct Selectable<E: Identifiable> {
    public var selected: E.ID?

    public init(
        items: [E],
        selected: E.ID? = nil
    ) {
        self.items = items
        self.selected = selected
    }

    public var items: [E] {
        didSet {
            if item == nil {
                selected = nil
            }
        }
    }

    public var item: E? {
        if let selected {
            return items[id: selected]
        }
        return nil
    }
}

// MARK: Equatable

extension Selectable: Equatable where E: Equatable {}
