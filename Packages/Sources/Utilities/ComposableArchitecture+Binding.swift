//
//  ComposableArchitecture+Binding.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/26/22.
//

import ComposableArchitecture
import SwiftUI

public extension ViewStore {
    func binding<ParentState, Value>(
        _ parentKeyPath: WritableKeyPath<ParentState, BindingState<Value>>,
        as keyPath: KeyPath<ViewState, Value>
    ) -> Binding<Value> where ViewAction: BindableAction, ViewAction.State == ParentState, Value: Equatable {
        binding(
            get: { $0[keyPath: keyPath] },
            send: { .binding(.set(parentKeyPath, $0)) }
        )
    }
}
