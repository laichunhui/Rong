//
//  UserDefaultsClient.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/13/22.
//

import ComposableArchitecture
import Foundation

// MARK: - UserDefaultsClient

public struct UserDefaultsClient {
    let dataForKey: @Sendable (String)
        -> Data?
    let boolForKey: @Sendable (String)
        -> Bool
    let doubleForKey: @Sendable (String)
        -> Double
    let intForKey: @Sendable (String)
        -> Int
    let setBool: @Sendable (String, Bool)
        async -> Void
    let setInt: @Sendable (String, Int)
        async -> Void
    let setDouble: @Sendable (String, Double)
        async -> Void
    let setData: @Sendable (String, Data?)
        async -> Void
    let remove: @Sendable (String) async -> Void
}

// MARK: UserDefaultsClient.Key

public extension UserDefaultsClient {
    struct Key<T> {
        let key: String
        let defaultValue: T

        public init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
    }
}

// Bool

public extension UserDefaultsClient.Key<Bool> {
    init(_ key: String) {
        self.key = key
        defaultValue = false
    }
}

// Data

public extension UserDefaultsClient.Key<Data?> {
    init(_ key: String) {
        self.key = key
        defaultValue = nil
    }
}

// Int

public extension UserDefaultsClient.Key<Int> {
    init(_ key: String) {
        self.key = key
        defaultValue = 0
    }
}

// Double

public extension UserDefaultsClient.Key<Double> {
    init(_ key: String) {
        self.key = key
        defaultValue = 0
    }
}

public extension UserDefaultsClient {
    func set(_ key: Key<Bool>, value: Bool) async {
        await setBool(key.key, value)
    }

    func set(_ key: Key<Data?>, value: Data?) async {
        await setData(key.key, value ?? key.defaultValue)
    }

    func set(_ key: Key<Int>, value: Int?) async {
        await setInt(key.key, value ?? key.defaultValue)
    }

    func set(_ key: Key<Double>, value: Double?) async {
        await setDouble(key.key, value ?? key.defaultValue)
    }

    func set<T: Codable>(_ key: Key<T>, value: T?) async {
        await setData(key.key, (try? value?.toData()) ?? (try? key.defaultValue.toData()))
    }
}

public extension UserDefaultsClient {
    func get(_ key: Key<Bool>) -> Bool {
        boolForKey(key.key)
    }

    func get(_ key: Key<Data?>) -> Data? {
        dataForKey(key.key) ?? key.defaultValue
    }

    func get(_ key: Key<Int>) -> Int {
        intForKey(key.key)
    }

    func get(_ key: Key<Double>) -> Double {
        doubleForKey(key.key)
    }

    func get<T: Codable>(_ key: Key<T>) -> T {
        (try? dataForKey(key.key)?.toObject()) ?? key.defaultValue
    }

    func get<T: Codable>(_ key: Key<T?>) -> T? {
        try? dataForKey(key.key)?.toObject() ?? key.defaultValue
    }
}

public extension UserDefaultsClient {
    func remove(_ key: Key<some Any>) async {
        await remove(key.key)
    }
}

// MARK: - UserDefaultsClientKey

private enum UserDefaultsClientKey: DependencyKey {
    static let liveValue = UserDefaultsClient.live
    static var previewValue = UserDefaultsClient.mock
}

public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClientKey.self] }
        set { self[UserDefaultsClientKey.self] = newValue }
    }
}
