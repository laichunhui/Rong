//
//  File.swift
//
//
//  Created by ErrorErrorError on 1/18/23.
//
//

import ComposableArchitecture
import Foundation

public extension TaskResult {
    var loadable: Loadable<Success> {
        switch self {
        case let .success(success):
            return .success(success)
        case let .failure(error):
            return .failed(error)
        }
    }
}
