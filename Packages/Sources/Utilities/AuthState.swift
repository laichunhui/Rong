//
//  AuthState.swift
//
//
//  Created by ErrorErrorError on 3/1/23.
//
//

import Foundation

// MARK: - AuthState

public enum AuthState<T: Equatable>: Equatable {
    case unauthenticated
    case authenticating
    case authenticated(T)
    case failed

    public func map<V: Equatable>(to value: @escaping (T) -> V) -> AuthState<V> {
        switch self {
        case .unauthenticated:
            return .unauthenticated
        case .authenticating:
            return .authenticating
        case let .authenticated(item):
            return .authenticated(value(item))
        case .failed:
            return .failed
        }
    }
}

public extension AuthState {
    init(capture body: @escaping @Sendable () async throws -> T) async {
        do {
            self = try await .authenticated(body())
        } catch {
            self = .failed
        }
    }
}
