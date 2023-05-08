//
//  Loadable.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/9/22.
//

import Foundation

// MARK: - Loadable

public enum Loadable<T> {
    case idle
    case loading
    case success(T)
    case failed(Error)
}

public extension Loadable {
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }

    var hasInitialized: Bool {
        switch self {
        case .idle:
            return false
        default:
            return true
        }
    }

    var finished: Bool {
        switch self {
        case .success, .failed:
            return true
        default:
            return false
        }
    }

    var successful: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var failed: Bool {
        switch self {
        case .failed:
            return true
        default:
            return false
        }
    }

    var value: T? {
        if case let .success(value) = self {
            return value
        }
        return nil
    }

    func map<N>(_ mapped: @escaping (T) -> N) -> Loadable<N> {
        switch self {
        case .idle:
            return .idle
        case .loading:
            return .loading
        case let .success(item):
            return .success(mapped(item))
        case let .failed(error):
            return .failed(error)
        }
    }
}

// MARK: Equatable

extension Loadable: Equatable where T: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.success(lhs), .success(rhs)):
            return lhs == rhs
        case let (.failed(lhs), .failed(rhs)):
            return String(reflecting: lhs) == String(reflecting: rhs)
        case (.loading, .loading), (.idle, .idle):
            return true
        default:
            return false
        }
    }
}

public extension Loadable {
    init(capture body: @Sendable () async throws -> T) async {
        do {
            self = try await .success(body())
        } catch {
            self = .failed(error)
        }
    }
}
