//
//  Effect+Send.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 10/22/22.
//

import ComposableArchitecture
import Foundation
import SwiftUI

public extension EffectTask where Failure == Never {
    /// Custom version of sending action using run
    static func action(
        priority: TaskPriority? = nil,
        _ action: Action,
        animation: Animation? = nil
    ) -> Self {
        run(priority: priority) { await $0(action, animation: animation) }
    }

    /// Custom version of `.fireAndForget` using run.
    static func run(_ operation: @escaping @Sendable () async throws -> Void) -> Self {
        run { _ in try await operation() }
    }

    /// Custom version of `.task` using run.
    static func run(_ operation: @escaping @Sendable () async throws -> Action) -> Self {
        run { try await $0(operation()) }
    }
}
