//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import Foundation
import ComposableArchitecture

public struct SettingReducer: ReducerProtocol {
    public struct State: Equatable {
        @BindableState
        var heroPosition = 0
        
        @BindingState
        public var userSettings: UserSettings
        
        public init(userSettings: UserSettings = UserSettings()) {
            self.userSettings = userSettings
        }
    }
    public enum Action: Equatable, BindableAction {
        case onAppear
        case binding(BindingAction<SettingReducer.State>)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
//        BindingReducer()
        Reduce(self.core)
    }
    
}

extension SettingReducer {
    func core(state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}


extension SettingReducer.State {
    var isLoading: Bool {
        return false
    }
}
