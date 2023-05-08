//
//  Array+Identifiable.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 10/1/22.
//

import Foundation
import OrderedCollections

// MARK: Identifiable

public extension Collection where Element: Identifiable, Self: RangeReplaceableCollection {
    mutating func update(_ element: Element) {
        if let index = firstIndex(where: { $0.id == element.id }) {
            remove(at: index)
            insert(element, at: index)
        } else {
            append(element)
        }
    }
}

// MARK: - IdentifiableArray

public protocol IdentifiableArray: Collection where Element: Identifiable {
    subscript(id _: Element.ID) -> Element? { get set }
}

// MARK: - Set + IdentifiableArray

extension Set: IdentifiableArray where Element: Identifiable {
    public subscript(id id: Element.ID) -> Element? {
        get {
            first { $0.id == id }
        }
        set {
            if let index = firstIndex(where: { obj in obj.id == id }) {
                remove(at: index)
                if let newValue {
                    insert(newValue)
                }
            } else {
                if let value = newValue {
                    insert(value)
                }
            }
        }
    }
}

// MARK: - Array + IdentifiableArray

extension Array: IdentifiableArray where Element: Identifiable {
    public subscript(id id: Element.ID) -> Element? {
        get {
            first { $0.id == id }
        }
        set {
            if let index = firstIndex(where: { obj in obj.id == id }) {
                if let value = newValue {
                    self[index] = value
                } else {
                    remove(at: index)
                }
            } else {
                if let value = newValue {
                    append(value)
                }
            }
        }
    }

    public func index(id: Element.ID) -> Int? {
        firstIndex { $0.id == id }
    }
}

public extension Set where Element: Identifiable {
    mutating func update(_ element: Element) {
        if let index = firstIndex(where: { $0.id == element.id }) {
            remove(at: index)
        }
        insert(element)
    }
}

// MARK: - OrderedSet + IdentifiableArray

extension OrderedSet: IdentifiableArray where Element: Identifiable {
    public subscript(id id: Element.ID) -> Element? {
        get {
            first { $0.id == id }
        }
        set {
            if let index = firstIndex(where: { $0.id == id }) {
                remove(at: index)
                if let value = newValue {
                    insert(value, at: index)
                }
            } else {
                if let value = newValue {
                    append(value)
                }
            }
        }
    }

    public func index(id: Element.ID) -> Int? {
        firstIndex { $0.id == id }
    }
}
