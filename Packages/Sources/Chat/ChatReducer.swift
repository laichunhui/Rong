//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import Foundation
import ComposableArchitecture

public struct ChatReducer: Reducer {
    public struct State: Equatable {
        var heroPosition = 0
        public init() {}
    }
    public enum Action: Equatable, BindableAction {
        case onAppear
        case binding(BindingAction<ChatReducer.State>)
    }
    
    public init() {}

    public var body: some Reducer<State, Action> {
//        BindingReducer()
        Reduce(self.core)
    }
    
}

extension ChatReducer {
    func core(state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}


extension ChatReducer.State {
    var isLoading: Bool {
        return false
    }
}
