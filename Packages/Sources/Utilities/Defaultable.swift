//
//  File.swift
//
//
//  Created by ErrorErrorError on 2/27/23.
//
//

import Foundation

// MARK: - Defaultable

@propertyWrapper
public struct Defaultable<Provider: DefaultValueProvider>: Codable {
    public var wrappedValue: Provider.Value

    public init() {
        self.wrappedValue = Provider.default
    }

    public init(wrappedValue: Provider.Value) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.wrappedValue = Provider.default
        } else {
            self.wrappedValue = try container.decode(Provider.Value.self)
        }
    }
}

// MARK: Equatable

extension Defaultable: Equatable where Provider.Value: Equatable {}

// MARK: Hashable

extension Defaultable: Hashable where Provider.Value: Hashable {}

public extension KeyedDecodingContainer {
    func decode<P>(_: Defaultable<P>.Type, forKey key: Key) throws -> Defaultable<P> {
        if let value = try decodeIfPresent(Defaultable<P>.self, forKey: key) {
            return value
        } else {
            return Defaultable()
        }
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<P>(_ value: Defaultable<P>, forKey key: Key) throws {
        guard value.wrappedValue != P.default else {
            return
        }
        try encode(value.wrappedValue, forKey: key)
    }
}

// MARK: - DefaultValueProvider

public protocol DefaultValueProvider {
    associatedtype Value: Equatable & Codable
    static var `default`: Value { get }
}

// MARK: - False

public enum False: DefaultValueProvider {
    public static let `default` = false
}

// MARK: - True

public enum True: DefaultValueProvider {
    public static let `default` = true
}

// MARK: - Empty

public enum Empty<A>: DefaultValueProvider where A: Codable, A: Equatable, A: RangeReplaceableCollection {
    public static var `default`: A { A() }
}

// MARK: - EmptyDictionary

public enum EmptyDictionary<K, V>: DefaultValueProvider where K: Hashable & Codable, V: Equatable & Codable {
    public static var `default`: [K: V] { Dictionary() }
}

// MARK: - Zero

public enum Zero: DefaultValueProvider {
    public static let `default` = 0
}

// MARK: - One

public enum One: DefaultValueProvider {
    public static let `default` = 1
}

// MARK: - ZeroDouble

public enum ZeroDouble: DefaultValueProvider {
    public static let `default`: Double = 0
}
