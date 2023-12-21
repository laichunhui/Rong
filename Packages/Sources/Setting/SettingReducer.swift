//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import Foundation
import ComposableArchitecture

public struct SettingReducer: Reducer {
    public struct State: Equatable {
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

    public var body: some Reducer<State, Action> {
//        BindingReducer()
        Reduce(self.core)
    }
    
}

extension SettingReducer {
    func core(state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}


extension SettingReducer.State {
    var isLoading: Bool {
        return false
    }
}
