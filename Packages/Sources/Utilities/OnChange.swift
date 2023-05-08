//
//  OnChange.swift
//
//
//  Created by ErrorErrorError on 1/16/23.
//
//  From: https://github.com/pointfreeco/isowords/blob/bb0a73d20495ca95167a01eeaaf591a540120ce2/Sources/TcaHelpers/OnChange.swift

import ComposableArchitecture
import Foundation

public extension ReducerProtocol {
    @inlinable
    func onChange<ChildState: Equatable>(
        of toLocalState: @escaping (State) -> ChildState,
        perform additionalEffects: @escaping (ChildState, inout State, Action) -> EffectTask<Action>
    ) -> some ReducerProtocol<State, Action> {
        onChange(of: toLocalState) { additionalEffects($1, &$2, $3) }
    }

    @inlinable
    func onChange<ChildState: Equatable>(
        of toLocalState: @escaping (State) -> ChildState,
        perform additionalEffects: @escaping (ChildState, ChildState, inout State, Action) -> EffectTask<Action>
    ) -> some ReducerProtocol<State, Action> {
        ChangeReducer(base: self, toLocalState: toLocalState, perform: additionalEffects)
    }
}

// MARK: - ChangeReducer

@usableFromInline
struct ChangeReducer<Base: ReducerProtocol, ChildState: Equatable>: ReducerProtocol {
    @usableFromInline
    let base: Base

    @usableFromInline
    let toLocalState: (Base.State) -> ChildState

    @usableFromInline
    let perform: (ChildState, ChildState, inout Base.State, Base.Action) -> EffectTask<Base.Action>

    @usableFromInline
    init(
        base: Base,
        toLocalState: @escaping (Base.State) -> ChildState,
        perform: @escaping (ChildState, ChildState, inout Base.State, Base.Action) -> EffectTask<Base.Action>
    ) {
        self.base = base
        self.toLocalState = toLocalState
        self.perform = perform
    }

    @inlinable
    func reduce(into state: inout Base.State, action: Base.Action) -> EffectTask<Base.Action> {
        let previousLocalState = toLocalState(state)
        let effects = base.reduce(into: &state, action: action)
        let localState = toLocalState(state)

        return previousLocalState != localState
            ? .merge(effects, perform(previousLocalState, localState, &state, action))
            : effects
    }
}
